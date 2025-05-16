//
//  AppleScriptNowPlayingInfoReader.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./AppleScriptNowPlayingInfoReader.h"
#import "../Entity/Media.h"

@implementation AppleScriptNowPlayingInfoReader
- (instancetype)init {
    self = [super init];

    if (self) {
        _payloadFilePath = [[NSBundle mainBundle] pathForResource:@"media-remote" ofType:@"js"];
        [NSTimer scheduledTimerWithTimeInterval:kNowPlayingInfoReaderReadInterval target:self selector:@selector(read) userInfo:nil repeats:YES];
    }

    return self;
}

- (void)read {
    NSTask* _Nonnull const task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/osascript"];
    [task setArguments:@[@"-l", @"JavaScript", _payloadFilePath]];

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

    NSString* _Nonnull const bundleId = json[kNowPlayingInfoKeyBundleId] ? json[kNowPlayingInfoKeyBundleId] : kMediaDefaultValueApplicationBundleIdentifier;
    BOOL const isPlaying = json[kNowPlayingInfoKeyIsPlaying] ? [json[kNowPlayingInfoKeyIsPlaying] boolValue] : kMediaDefaultValueIsPlaying;
    NSString* _Nonnull const title = json[kNowPlayingInfoKeyTitle] ? json[kNowPlayingInfoKeyTitle] : kMediaDefaultValueTitle;
    NSString* _Nullable const artist = json[kNowPlayingInfoKeyArtist] ? json[kNowPlayingInfoKeyArtist] : kMediaDefaultValueSubtitle;
    NSString* _Nullable const album = json[kNowPlayingInfoKeyAlbum] ? json[kNowPlayingInfoKeyAlbum] : kMediaDefaultValueDetails;
    CGFloat const duration = json[kNowPlayingInfoKeyDuration] ? [json[kNowPlayingInfoKeyDuration] doubleValue] : kMediaDefaultValueDuration;
    CGFloat const elapsed = json[kNowPlayingInfoKeyElapsed] ? [json[kNowPlayingInfoKeyElapsed] doubleValue] : kMediaDefaultValueElapsed;

    if (error || [bundleId isEqualToString:kMediaDefaultValueApplicationBundleIdentifier]) {
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
