//
//  PlayableFactory.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "../Entity/Media.h"
#import "../Fetcher/ItunesCoverFetcher.h"
#import "./MediaFactory.h"
#import "../Provider/NowPlayingInfoProviderProtocol.h"
#import "../Util/Logger.h"

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
    [media setApplicationBundleIdentifier:nowPlayingInfo[kNowPlayingInfoKeyBundleIdentifier]];
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
    [media setCoverUrl:[_itunesCoverFetcher fetchCoverUrlForMedia:media]];
    
    [[Logger sharedInstance] logMessage:[NSString stringWithFormat:@"Created media object from now playing info: %@", [media jsonSerialize]] forType:LogTypeInfo];

    return media;
}
@end
