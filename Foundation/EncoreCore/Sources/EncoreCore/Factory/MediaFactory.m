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
    [media setSubtitle:nowPlayingInfo[kNowPlayingInfoKeyArtist]];
    [media setDetails:nowPlayingInfo[kNowPlayingInfoKeyAlbum]];
    [media setDuration:[nowPlayingInfo[kNowPlayingInfoKeyDuration] doubleValue]];
    [media setElapsed:[nowPlayingInfo[kNowPlayingInfoKeyElapsed] doubleValue]];
    [media setCoverUrl:[_itunesCoverFetcher fetchCoverUrlForMedia:media]];
    return media;
}
@end
