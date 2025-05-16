//
//  EncoreCore.hpp
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>
#import "../Reader/NowPlayingInfoReaderProtocol.h"

@class ItunesTrackFetcher;
@class ArtworkFetcher;

static NSUInteger const kTimeoutReconnect = 5;
static NSUInteger const kTimeoutCallback = 1;
static NSUInteger const kTimeoutUpdate = 1;

static NSString* _Nullable const kClientIdNone = nil;

@interface EncoreCore : NSObject {
    ItunesTrackFetcher* _Nonnull _iTunesTrackFetcher;
    ArtworkFetcher* _Nonnull _artworkFetcher;
}
@property(nonatomic)id<NowPlayingInfoReaderProtocol> _Nonnull const nowPlayingInfoReader;
@end
