//
//  AppleScriptNowPlayingInfoReader.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./AppleScriptNowPlayingInfoReader.h"

@implementation AppleScriptNowPlayingInfoReader
- (instancetype)init {
    self = [super init];

    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:kNowPlayingInfoReaderReadInterval target:self selector:@selector(read) userInfo:nil repeats:YES];
    }

    return self;
}

- (void)read {
    NSTask* _Nonnull const task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/osascript"];
    [task setArguments:@[@"-l", @"JavaScript", [[NSBundle mainBundle] pathForResource:@"media-remote" ofType:@"js"]]];

    NSPipe* _Nonnull const pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:[NSPipe pipe]];
    [task launch];
    [task waitUntilExit];

    NSData* _Nonnull const data = [[pipe fileHandleForReading] readDataToEndOfFile];
    NSString* _Nonnull const output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* _Nonnull const jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
    NSError* _Nullable error = nil;
    NSDictionary* _Nullable const json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    NSString* _Nonnull const bundleId = json[kNowPlayingInfoKeyBundleId] ? json[kNowPlayingInfoKeyBundleId] : @"";
    BOOL const isPlaying = json[kNowPlayingInfoKeyIsPlaying] ? [json[kNowPlayingInfoKeyIsPlaying] boolValue] : NO;
    NSString* _Nonnull const title = json[kNowPlayingInfoKeyTitle] ? json[kNowPlayingInfoKeyTitle] : @"";
    NSString* _Nullable const artist = json[kNowPlayingInfoKeyArtist] ? json[kNowPlayingInfoKeyArtist] : @"";
    NSString* _Nullable const album = json[kNowPlayingInfoKeyAlbum] ? json[kNowPlayingInfoKeyAlbum] : @"";
    CGFloat const duration = json[kNowPlayingInfoKeyDuration] ? [json[kNowPlayingInfoKeyDuration] doubleValue] : 0;
    CGFloat const elapsed = json[kNowPlayingInfoKeyElapsed] ? [json[kNowPlayingInfoKeyElapsed] doubleValue] : 0;

    if (error || !bundleId) {
        _nowPlayingInfo = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameNowPlayingInfoChanged object:nil userInfo:nil];
        return;
    }

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
}
@end
