//
//  EncoreCore.hpp
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "../Provider/NowPlayingInfoProviderProtocol.h"
#import "../Entity/Media.h" // This import is required for EncoreCoreBridge.
#import "../Util/Logger.h" // This import is required for EncoreCoreBridge.

@class DiscordActivityFactory;
@class MediaFactory;

static NSUInteger const kTimeoutReconnect = 5;
static NSUInteger const kTimeoutCallback = 1;
static NSUInteger const kTimeoutUpdate = 1;

static NSString* _Nullable const kClientIdNone = nil;

@interface EncoreCore : NSObject {
    id<NowPlayingInfoProviderProtocol> _Nonnull _nowPlayingInfoProvider;
    MediaFactory* _Nonnull _mediaFactory;
    DiscordActivityFactory* _Nonnull _discordActivityFactory;
}
@property(nonatomic)Media* _Nullable const media;
@end
