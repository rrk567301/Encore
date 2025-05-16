//
//  MediaRemoteNowPlayingInfoProvider.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./NowPlayingInfoProviderProtocol.h"

@interface MediaRemoteNowPlayingInfoProvider : NSObject <NowPlayingInfoProviderProtocol> {
    NSTimer* _Nonnull _timer;
    NSDictionary* _Nullable _nowPlayingInfo;
}
@end
