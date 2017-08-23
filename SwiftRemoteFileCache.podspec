Pod::Spec.new do |s|
    s.name         = "SwiftRemoteFileCache"
    s.version      = "0.0.5"
    s.summary      = "Manages a cache of remote files for use, based on their relative priority level."
    s.homepage     = "https://github.com/briankeane/SwiftRemoteFileCache.git"
    s.license      = { :type => 'MIT' }
    s.author       = { "Brian Keane" => "brian@playola.fm" }
    s.ios.deployment_target = '10.3'
    s.osx.deployment_target = '10.12'
    s.source       = { :git => "https://github.com/briankeane/SwiftRemoteFileCache.git", :tag => s.version }
    s.exclude_files = []
    # s.ios.frameworks = 'AudioToolbox','AVFoundation','GLKit', 'Accelerate'
    # s.osx.frameworks = 'AudioToolbox','AudioUnit','CoreAudio','QuartzCore','OpenGL','GLKit', 'Accelerate'
    # s.requires_arc = true;
    # s.default_subspec = 'Full'
    s.dependency 'Alamofire', '4.5.0'
    s.source_files = 'Sources/*.{h,m,swift}'

    # probably will use this later when start subSpecing (PlayolaCore-Player, PlayolaCore-Core, etc)
    # s.subspec 'Core' do |core|
    #     core.source_files  = 'Sources/*.{h,m,swift}'
    # end


    # s.subspec 'Full' do |full|
    #     full.dependency 'Alamofire', '4.5.0'
    #     full.dependency 'PromiseKit', '~> 4.0'
    # end
end
