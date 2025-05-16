//
//  PlayableFactory.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "../Entity/Media.h"
#import "../Fetcher/ItunesCoverFetcher.h"
#import "./MediaFactory.h"
#import "../Reader/NowPlayingInfoReaderProtocol.h"

@implementation MediaFactory
- (instancetype _Nonnull const)init {
    self = [super init];

    if (self) {
        _itunesCoverFetcher = [[ItunesCoverFetcher alloc] init];
    }

    return self;
}

- (Media* _Nonnull const)createForNowPlayingInfo:(NSDictionary* _Nonnull const)nowPlayingInfo {
    Media* _Nonnull const media = [[Media alloc] init];
    [media setApplicationBundleIdentifier:nowPlayingInfo[kNowPlayingInfoKeyBundleId]];
    [media setIsPlaying:[nowPlayingInfo[kNowPlayingInfoKeyIsPlaying] boolValue]];
    [media setTitle:nowPlayingInfo[kNowPlayingInfoKeyTitle]];

    NSString* _Nullable const subtitle = nowPlayingInfo[kNowPlayingInfoKeyArtist];
    if (![subtitle isEqualToString:kMediaDefaultValueSubtitle]) {
        [media setSubtitle:subtitle];
    }

    NSString* _Nullable const details = nowPlayingInfo[kNowPlayingInfoKeyAlbum];
    if (![details isEqualToString:kMediaDefaultValueDetails]) {
        [media setDetails:details];
    }

    [media setDuration:[nowPlayingInfo[kNowPlayingInfoKeyDuration] doubleValue]];
    [media setElapsed:[nowPlayingInfo[kNowPlayingInfoKeyElapsed] doubleValue]];

    // Fetching the cover for paused media is unncessary.
    // It wouldn't be used anyway, since the RPC connection is only establishsed for playing media.
    if ([media isPlaying]) {
        [media setCoverUrl:[_itunesCoverFetcher fetchCoverUrlForMedia:media]];
    }

    return media;
}
@end
