//
//  AppleScriptNowPlayingInfoProvider.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./NowPlayingInfoProviderProtocol.h"

@interface AppleScriptNowPlayingInfoProvider : NSObject <NowPlayingInfoProviderProtocol> {
    NSFileManager* _Nonnull _fileManager;
    NSString* _Nonnull _payloadFilePath;
    NSTimer* _Nonnull _timer;
    NSDictionary* _Nullable _nowPlayingInfo;
}
@end
