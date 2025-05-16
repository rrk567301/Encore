//
//  Media.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./Media.h"

@implementation Media
- (NSDictionary* _Nonnull const)jsonSerialize {
    return @{
        @"application_bundle_identifier": [self applicationBundleIdentifier],
        @"is_playing": @([self isPlaying]),
        @"title": [self title],
        @"subtitle": [self subtitle] ? [self subtitle] : @"",
        @"details": [self details] ? [self details] : @"",
        @"cover_url": [self coverUrl] ? [self coverUrl] : @"",
        @"elapsed": @([self elapsed]),
        @"duration": @([self duration])
    };
}
@end
