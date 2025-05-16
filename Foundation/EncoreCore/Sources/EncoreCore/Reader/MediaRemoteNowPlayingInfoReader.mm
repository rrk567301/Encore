//
//  MediaRemoteNowPlayingInfoReader.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <AppKit/AppKit.h>

#import "./MediaRemote.h"
#import "./MediaRemoteNowPlayingInfoReader.hpp"

@implementation MediaRemoteNowPlayingInfoReader
- (instancetype)init {
    self = [super init];

    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:kNowPlayingInfoReaderReadInterval target:self selector:@selector(read) userInfo:nil repeats:YES];
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
                NSString* _Nonnull const bundleId = [[NSRunningApplication runningApplicationWithProcessIdentifier:pId] bundleIdentifier];
                NSString* _Nonnull const title = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] ? nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] : @"";
                NSString* _Nullable const artist = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] ? nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] : @"";
                NSString* _Nullable const album = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] ? nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] : @"";
                CGFloat const duration = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration] ? [nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration] doubleValue] : 0;
                CGFloat const elapsed = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] ? [nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] doubleValue] : 0;

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
                    kNowPlayingInfoKeyBundleId: bundleId,
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
