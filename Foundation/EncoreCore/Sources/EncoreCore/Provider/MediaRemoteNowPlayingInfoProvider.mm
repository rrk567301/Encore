//
//  MediaRemoteNowPlayingInfoProvider.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <AppKit/AppKit.h>

#import "../Entity/Media.h"
#import "./MediaRemote.h"
#import "./MediaRemoteNowPlayingInfoProvider.hpp"

@implementation MediaRemoteNowPlayingInfoProvider
- (instancetype)init {
    self = [super init];

    if (self) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kNowPlayingInfoProviderReadInterval target:self selector:@selector(read) userInfo:nil repeats:YES];
    }

    return self;
}

- (void)read {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef _Nullable const info) {
        if (!info) {
            _nowPlayingInfo = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameNowPlayingInfoChanged object:nil userInfo:nil];
            return;
        }
        NSDictionary* _Nonnull const nowPlayingInfo = (__bridge NSDictionary *)info;

        MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean const isPlaying) {
            MRMediaRemoteGetNowPlayingApplicationPID(dispatch_get_main_queue(), ^(int const pId) {
                NSString* _Nonnull const bundleIdentifier = [[NSRunningApplication runningApplicationWithProcessIdentifier:pId] bundleIdentifier];
                NSString* _Nonnull const title = nowPlayingInfo[kMediaRemoteTitleKey] ? nowPlayingInfo[kMediaRemoteTitleKey] : kMediaDefaultValueTitle;
                NSString* _Nullable const artist = nowPlayingInfo[kMediaRemoteArtistKey] ? nowPlayingInfo[kMediaRemoteArtistKey] : kMediaDefaultValueSubtitle;
                NSString* _Nullable const album = nowPlayingInfo[kMediaRemoteAlbumKey] ? nowPlayingInfo[kMediaRemoteAlbumKey] : kMediaDefaultValueDetails;
                CGFloat const duration = nowPlayingInfo[kMediaRemoteDurationKey] ? [nowPlayingInfo[kMediaRemoteDurationKey] doubleValue] : kMediaDefaultValueDuration;
                CGFloat const elapsed = nowPlayingInfo[kMediaRemoteElapsedTimeKey] ? [nowPlayingInfo[kMediaRemoteElapsedTimeKey] doubleValue] : kMediaDefaultValueElapsed;

                if ([_nowPlayingInfo[kNowPlayingInfoKeyIsPlaying] boolValue] == isPlaying &&
                    [_nowPlayingInfo[kNowPlayingInfoKeyTitle] isEqualToString:title] &&
                    [_nowPlayingInfo[kNowPlayingInfoKeyArtist] isEqualToString:artist] &&
                    [_nowPlayingInfo[kNowPlayingInfoKeyAlbum] isEqualToString:album] &&
                    [_nowPlayingInfo[kNowPlayingInfoKeyDuration] doubleValue] == duration &&
                    [_nowPlayingInfo[kNowPlayingInfoKeyElapsed] doubleValue] == elapsed
                ) {
                    return;
                }

                _nowPlayingInfo = @{
                    kNowPlayingInfoKeyBundleIdentifier: bundleIdentifier,
                    kNowPlayingInfoKeyIsPlaying: @(isPlaying),
                    kNowPlayingInfoKeyTitle: title,
                    kNowPlayingInfoKeyArtist: artist,
                    kNowPlayingInfoKeyAlbum: album,
                    kNowPlayingInfoKeyDuration: @(duration),
                    kNowPlayingInfoKeyElapsed: @(elapsed)
                };

                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameNowPlayingInfoChanged object:nil userInfo:_nowPlayingInfo];
            });
        });
    });
}
@end
