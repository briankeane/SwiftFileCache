//
//  RemoteFileCacheManager.swift
//  SwiftRemoteFileCache
//
//  Created by Brian D Keane on 8/21/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Foundation

import Foundation
var AUDIO_FILE_CACHE_MAX_SIZE = 52428800  // 50 MB Cache for now

// -----------------------------------------------------------------------------
//                      class RemoteFileCacheManager
// -----------------------------------------------------------------------------
/// handles all downloading of mp3s -- initialized as Singletons
/// ----------------------------------------------------------------------------
class RemoteFileCacheManager
{
    /// a dictionary of all AudioCacheObjects currently being downloaded
    var inProgress:Dictionary<URL, RemoteFileDownloader>! = Dictionary()
    
    /// the folder to store this service's files in
    var audioFileDirectoryURL:URL!
    
    /// a dictionary that holds all currently active AudioFileCachePriorities for this service
    var filePriorities:Dictionary<String,RemoteFilePriorityLevel>! = Dictionary()
    
    // -----------------------------------------------------------------------------
    //                          func init
    // -----------------------------------------------------------------------------
    /// initializer
    ///
    /// - parameters:
    ///     - subFolder: `(String)` - the subfolder for storing these files... if
    ///                               it doesn't exist it will be created.
    /// ----------------------------------------------------------------------------
    init(subFolder:String! = "AudioFiles")
    {
        // IF there is no AudioFile folder yet, create it
        // create folder if it does not already exist
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectoryURL:URL = URL(fileURLWithPath: paths[0])
        audioFileDirectoryURL = documentsDirectoryURL.appendingPathComponent(subFolder)
        
        let fileManager = FileManager.default
        do
        {
            try fileManager.createDirectory(atPath: audioFileDirectoryURL.path, withIntermediateDirectories: false, attributes: nil)
        }
        catch let error as NSError
        {
            print(error.localizedDescription);
        }
    }
    
    // -----------------------------------------------------------------------------
    //                          func localURLFromRemoteURL
    // -----------------------------------------------------------------------------
    /// returns the full url for the location of a file
    ///
    /// - parameters:
    ///     - filename: `(String)` - the key for the file
    ///
    /// - returns:
    ///    `NSURL` - the full NSURL for the file's correct location
    /// ----------------------------------------------------------------------------
    func localURLFromRemoteURL(_ remoteURL:URL) -> URL
    {
        let filename = remoteURL.lastPathComponent
        return audioFileDirectoryURL.appendingPathComponent(filename)
    }
    
    // -----------------------------------------------------------------------------
    //                          func reportDownloadComplete
    // -----------------------------------------------------------------------------
    /// removes a cacheObject from the inProgress Dictionary
    ///
    /// - parameters:
    ///     - cacheObject: `(AudioCacheObject)` - the AudioCacheObject to remove
    /// ----------------------------------------------------------------------------
    func reportDownloadComplete(_ remoteURL:URL)
    {
        self.inProgress.removeValue(forKey: remoteURL)
    }
    
    // -----------------------------------------------------------------------------
    //                          func pauseDownloads
    // -----------------------------------------------------------------------------
    /// suspends all downloads
    ///
    /// ----------------------------------------------------------------------------
    func pauseDownloads()
    {
        for (_, cachedObject) in self.inProgress
        {
            cachedObject.pauseDownload()
        }
    }
    
    // -----------------------------------------------------------------------------
    //                          func calculateFolderCacheSize
    // -----------------------------------------------------------------------------
    // adapted from http://stackoverflow.com/questions/32814535/how-to-get-directory-size-with-swift-on-os-x
    // -----------------------------------------------------------------------------
    /// calculates the total current size of the cache
    ///
    /// - returns:
    ///    `Int` - the folder size in Bytes
    /// ----------------------------------------------------------------------------
    func calculateFolderCacheSize() -> Int
    {
        // check if the url is a directory
        var bool: ObjCBool = false
        var folderFileSizeInBytes = 0
        
        if FileManager().fileExists(atPath: self.audioFileDirectoryURL.path, isDirectory: &bool)
        {
            if bool.boolValue
            {
                // lets get the folder files
                let fileManager =  FileManager.default
                let files = try! fileManager.contentsOfDirectory(at: self.audioFileDirectoryURL, includingPropertiesForKeys: nil, options: [])
                for file in files
                {
                    folderFileSizeInBytes +=  try! (fileManager.attributesOfItem(atPath: file.path) as NSDictionary).fileSize().hashValue
                }
                // format it using NSByteCountFormatter to display it properly
                let  byteCountFormatter =  ByteCountFormatter()
                byteCountFormatter.allowedUnits = .useBytes
                byteCountFormatter.countStyle = .file
                return folderFileSizeInBytes
            }
        }
        return folderFileSizeInBytes
    }
    
    // -----------------------------------------------------------------------------
    //                          func pruneCache
    // -----------------------------------------------------------------------------
    /// deletes all lower priority files
    /// ----------------------------------------------------------------------------
    func pruneCache()
    {
        var currentSize = self.calculateFolderCacheSize()
        while (currentSize > AUDIO_FILE_CACHE_MAX_SIZE)
        {
            if let fileTuples = self.getDeletableFiles()
            {
                for i in 0..<fileTuples.count
                {
                    if (fileTuples[i].2 == RemoteFilePriorityLevel.doNotDelete)
                    {
                        continue
                    }
                    else
                    {
                        self.deleteAudioFile(fileTuples[i].0)
                        currentSize = self.calculateFolderCacheSize()
                        if (currentSize < AUDIO_FILE_CACHE_MAX_SIZE)
                        {
                            break
                        }
                    }
                }
            }
        }
    }
    
    // -----------------------------------------------------------------------------
    //                          func deleteAudioFile
    // -----------------------------------------------------------------------------
    /// deletes the audioFile with the given filename
    ///
    /// - parameters:
    ///     - filename: `(String)` - the filename of the file to delete
    /// ----------------------------------------------------------------------------
    func deleteAudioFile(_ filename:String)
    {
        // Create a FileManager instance
        let fileManager = FileManager.default
        
        do
        {
            try fileManager.removeItem(atPath: audioFileDirectoryURL.appendingPathComponent(filename).path)
        }
        catch let error as NSError
        {
            print("Error trying to delete file from audioCache: \(error)")
        }
    }
    
    
    // -----------------------------------------------------------------------------
    //                          func getDeletableFiles
    // -----------------------------------------------------------------------------
    // Adapted from http://stackoverflow.com/questions/33032293/swift-2-ios-get-file-list-sorted-by-creation-date-more-concise-solution
    // -----------------------------------------------------------------------------
    /// calculates all deletable files
    ///
    /// - returns:
    ///    `Array<(String, NSTimeInterval, AudioFileCachePriority)>?` - an array of tuples containing:
    ///         -- String -- the filename
    ///         -- NSTimeInterval -- the time the file was last modified
    ///         -- AudioFileCachePriority -- the priority of the file
    /// ----------------------------------------------------------------------------
    func getDeletableFiles() -> Array<(String, TimeInterval, RemoteFilePriorityLevel)>?
    {
        
        // comparison
        func deletability(_ tuple1:(String, TimeInterval, RemoteFilePriorityLevel), tuple2:(String, TimeInterval, RemoteFilePriorityLevel)) -> Bool
        {
            if (tuple1.2 == tuple2.2)
            {
                return tuple1.1 < tuple2.1
            }
            else
            {
                return tuple1.2.rawValue < tuple2.2.rawValue
            }
        }
        
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: audioFileDirectoryURL,
                                                                       includingPropertiesForKeys: [URLResourceKey.localizedNameKey, URLResourceKey.contentModificationDateKey], options:.skipsHiddenFiles)
        {
            var tupleMap = urlArray.map
            {
                url -> (String, TimeInterval, RemoteFilePriorityLevel) in
                var lastModified : AnyObject?
                _ = try? (url as NSURL).getResourceValue(&lastModified, forKey: URLResourceKey.contentModificationDateKey)
                return (url.lastPathComponent, lastModified?.timeIntervalSinceReferenceDate ?? 0, self.filePriorities[url.lastPathComponent] ?? RemoteFilePriorityLevel.unspecified)
            }
            
            tupleMap = tupleMap.sorted(by: deletability) // sort descending modification dates
            
            //            // UNCOMMENT for debugging cache
            //            print("---------------- IS SORTING CORRECT? ------------------")
            //            print(tupleMap)
            return tupleMap
        }
        else
        {
            return nil
        }
    }
    
    // -----------------------------------------------------------------------------
    //                          func downloadFile
    // -----------------------------------------------------------------------------
    /// downloads a file
    ///
    /// - parameters:
    ///     - remoteURL: `(URL)` - the remote url of the file to download
    ///
    /// - returns:
    ///    `RemoteFileDownloader` - the RemoteFileDownloader managing the active download.
    /// ----------------------------------------------------------------------------
    func downloadFile(_ remoteURL:URL) -> RemoteFileDownloader
    {
        // if a downloader is already in progress for that file
        if let downloader = self.inProgress[remoteURL]
        {
            downloader.resumeDownload()
            return downloader
        }
        
        let downloader = RemoteFileDownloader(remoteURL: remoteURL, localURL: self.localURLFromRemoteURL(remoteURL))
        .onCompletion
        {
            (downloader) -> Void in
            self.inProgress[downloader.remoteURL] = nil
            self.pruneCache()
        }
        
        
        downloader.beginDownload()
        self.inProgress[remoteURL] = downloader
        return downloader
    }
}
