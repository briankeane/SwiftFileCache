//
//  RemoteFileCacheManagerTests.swift
//  SwiftRemoteFileCache
//
//  Created by Brian D Keane on 8/21/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import XCTest
//import Quick
//import Nimble

//class RemoteFileCacheManagerTests: QuickSpec
//{
//    override func spec()
//    {
//        describe("RemoteFileCacheManagerTests")
//        {
//            var paths:[String] = []
//            var documentsDirectory:URL = URL(fileURLWithPath: "")
//            var finalDestinationURL:URL = URL(fileURLWithPath: "")
//            var remoteFileCacheMonitor:RemoteFileCacheManager = RemoteFileCacheManager()
//
//            beforeEach
//            {
//                paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//                documentsDirectory = URL(fileURLWithPath: paths[0])
//                finalDestinationURL = documentsDirectory.appendingPathComponent("AudioFiles/bob.mp3")
//                remoteFileCacheManager = RemoteFileCacheManager()
//            }
//
//            afterEach
//            {
//                if FileManager.default.fileExists(atPath: finalDestinationURL.path)
//                {
//                    do
//                    {
//                        try FileManager.default.removeItem(atPath: finalDestinationURL.path)
//                    }
//                    catch
//                    {
//                        print(error)
//                    }
//                }
//            }
//
//            it ("returns false for unCached")
//            {
//                expect(remoteFileCacheMonitor.isCached("bob.mp3")).to(equal(false))
//            }
//
//            it ("returns true for a cached file")
//            {
//                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//                let documentsDirectory:URL = URL(fileURLWithPath: paths[0])
//                let audioFilesDirectory:URL = documentsDirectory.appendingPathComponent("AudioFiles")
//                let finalDestinationURL:URL = audioFilesDirectory.appendingPathComponent("bob.mp3")
//
//                do
//                {
//                    let string:String = "test"
//                    try FileManager.default.createDirectory(atPath: audioFilesDirectory.path, withIntermediateDirectories: true, attributes: nil)
//                    try string.write(toFile: finalDestinationURL.path, atomically: true, encoding: String.Encoding.utf8)
//                }
//                catch
//                {
//                    expect(true).to(equal(false))  // should never run... file creation failed
//                }
//                expect(remoteFileCacheManager.isCached("bob.mp3")).to(equal(true))
//            }
//
//            it ("updates the download progress when complete")
//            {
//                // put "downloaded" file in place
//                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//                let documentsDirectory:URL = URL(fileURLWithPath: paths[0])
//                let audioFilesDirectory:URL = documentsDirectory.appendingPathComponent("AudioFiles")
//                let finalDestinationURL:URL = audioFilesDirectory.appendingPathComponent("bob.mp3")
//                do
//                {
//                    let string:String = "test"
//                    try FileManager.default.createDirectory(atPath: audioFilesDirectory.path, withIntermediateDirectories: true, attributes: nil)
//                    try string.write(toFile: finalDestinationURL.path, atomically: true, encoding: String.Encoding.utf8)
//                }
//                catch
//                {
//                    XCTFail("failed to create file")
//                }
//
//                let audioBlock = AudioBlock(audioBlockInfo: ["key":"bob.mp3" as AnyObject])
//                audioBlock.audioFileUrl = "https://songs.playola.fm/bob.mp3"
//                let cacheObject:AudioCacheObject = AudioFileCacheInstance.downloadAudio(audioBlock)
//
//                expect(cacheObject.downloadProgress).to(equal(1.0))
//            }
//
//            it ("updates the download progress when not quite complete")
//            {
//                let audioBlock = AudioBlock(audioBlockInfo: ["key":"bob.mp3" as AnyObject])
//                audioBlock.audioFileUrl = "https://songs.playola.fm/bob.mp3"
//                let injectedCacheObject:AudioCacheObject = AudioCacheObject(audioBlock: audioBlock)
//                injectedCacheObject.downloadProgress = 0.4
//                AudioFileCacheInstance.inProgress[audioBlock.key!] = injectedCacheObject
//
//                let gottenCacheObject:AudioCacheObject = AudioFileCacheInstance.downloadAudio(audioBlock)
//                expect(gottenCacheObject.downloadProgress).to(equal(0.4))
//            }
//
//            it ("works for a brand new download that has not downloaded")
//            {
//                let audioBlock = AudioBlock(audioBlockInfo: ["key":"bob.mp3" as AnyObject,
//                                                             "audioFileUrl":"bobsUrl" as AnyObject])
//                let gottenCacheObject:AudioCacheObject = AudioFileCacheInstance.downloadAudio(audioBlock)
//                XCTAssertEqual(gottenCacheObject.downloadProgress, 0.0)
//                expect(gottenCacheObject.downloadProgress).to(equal(0.0))
//            }
//
//            it("returns a proper URL from a key")
//            {
//                let expectedURL = documentsDirectory.appendingPathComponent("AudioFiles/bob.mp3")
//                expect(AudioFileCacheInstance.URLFromKey("bob.mp3")).to(equal(expectedURL))
//            }
//        }
//
//    }
//}
