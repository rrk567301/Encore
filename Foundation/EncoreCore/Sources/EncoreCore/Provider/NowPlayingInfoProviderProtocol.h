//
//  NowPlayingInfoProviderProtocol.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

static NSUInteger const kNowPlayingInfoProviderReadInterval = 1;

static NSString* _Nonnull const kNowPlayingInfoKeyBundleIdentifier = @"bundle_identifier";
static NSString* _Nonnull const kNowPlayingInfoKeyIsPlaying = @"is_playing";
static NSString* _Nonnull const kNowPlayingInfoKeyTitle = @"title";
static NSString* _Nonnull const kNowPlayingInfoKeyAlbum = @"album";
static NSString* _Nonnull const kNowPlayingInfoKeyArtist = @"artist";
static NSString* _Nonnull const kNowPlayingInfoKeyDuration = @"duration";
static NSString* _Nonnull const kNowPlayingInfoKeyElapsed = @"elapsed";

static NSString* _Nonnull const kNotificationNameNowPlayingInfoChanged = @"nowPlayingInfoChanged";

@protocol NowPlayingInfoProviderProtocol
@required
- (void)read;
@end
