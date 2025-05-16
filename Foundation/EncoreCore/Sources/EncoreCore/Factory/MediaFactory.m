//
//  PlayableFactory.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "../Cache/Cache.h"
#import "../Entity/Media.h"
#import "../Extension/NSString+xxHash.h"
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
    Media* _Nullable const cachedMedia = [self cachedMediaForNowPlayingInfo:nowPlayingInfo];

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

    if (cachedMedia) {
        [[Logger sharedInstance] logMessage:[NSString stringWithFormat:@"[Core] Using cover URL from cache: %@", [cachedMedia coverUrl]] forType:LogTypeInfo];
        [media setCoverUrl:[cachedMedia coverUrl]];
    } else {
        [media setCoverUrl:[_itunesCoverFetcher fetchCoverUrlForMedia:media]];
    }

    [[Logger sharedInstance] logMessage:[NSString stringWithFormat:@"[Core] Created media object: %@", [media jsonSerialize]] forType:LogTypeInfo];

    if ([media shouldBeCached]) {
        [self cacheMedia:media];
    }

    return media;
}

- (Media* _Nullable const)cachedMediaForNowPlayingInfo:(NSDictionary* _Nonnull const)nowPlayingInfo {
    NSString* _Nonnull const key = [self cacheKeyForTitle:nowPlayingInfo[kNowPlayingInfoKeyTitle] subtitle:nowPlayingInfo[kNowPlayingInfoKeyArtist] ?: @"" details:nowPlayingInfo[kNowPlayingInfoKeyAlbum] ?: @""];
    NSData* _Nullable const data = [[Cache sharedInstance] dataForKey:key];

    if (data) {
        NSError* _Nullable error = nil;
        NSSet<Class>* _Nonnull const allowedClasses = [NSSet setWithObjects:[Media class], [NSString class], [NSURL class], nil];
        id _Nullable const media = [NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:data error:&error];

        if (error) {
            [[Logger sharedInstance] logMessage:[NSString stringWithFormat:@"[Core] Error unarchiving media object: %@", [error localizedDescription]] forType:LogTypeError];
            return nil;
        }

        return media;
    }

    return nil;
}

- (void)cacheMedia:(Media* _Nonnull const)media {
    NSString* _Nonnull const key = [self cacheKeyForTitle:[media title] subtitle:[media subtitle] ?: @"" details:[media details] ?: @""];
    NSError* _Nullable error = nil;
    NSData* _Nonnull const data = [NSKeyedArchiver archivedDataWithRootObject:media requiringSecureCoding:YES error:&error];

    if (error) {
        [[Logger sharedInstance] logMessage:[NSString stringWithFormat:@"[Core] Error archiving media object: %@", [error localizedDescription]] forType:LogTypeError];
        return;
    }

    [[Cache sharedInstance] writeData:data forKey:key];
}

- (NSString* _Nonnull const)cacheKeyForTitle:(NSString* _Nonnull const)title subtitle:(NSString* _Nonnull const)subtitle details:(NSString* _Nonnull const)details {
    return [[NSString stringWithFormat:@"%@%@%@", title, subtitle, details] xxh64];
}
@end
