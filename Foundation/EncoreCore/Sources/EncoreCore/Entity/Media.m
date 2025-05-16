//
//  Media.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./Media.h"

@implementation Media
- (BOOL)shouldBeCached {
    return [self coverUrl];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder* _Nonnull const)coder {
    [coder encodeObject:[self applicationBundleIdentifier] forKey:kMediaKeyApplicationBundleIdentifier];
    [coder encodeBool:[self isPlaying] forKey:kMediaKeyIsPlaying];
    [coder encodeObject:[self title] forKey:kMediaKeyTitle];
    [coder encodeObject:[self subtitle] forKey:kMediaKeySubtitle];
    [coder encodeObject:[self details] forKey:kMediaKeyDetails];
    [coder encodeObject:[self coverUrl] forKey:kMediaKeyCoverUrl];
    [coder encodeDouble:[self duration] forKey:kMediaKeyDuration];
    [coder encodeDouble:[self elapsed] forKey:kMediaKeyElapsed];
}

- (instancetype _Nullable const)initWithCoder:(NSCoder* _Nonnull const)coder {
    self = [super init];

    if (self) {
        [self setApplicationBundleIdentifier:[coder decodeObjectOfClass:[NSString class] forKey:kMediaKeyApplicationBundleIdentifier]];
        [self setIsPlaying:[coder decodeBoolForKey:kMediaKeyIsPlaying]];
        [self setTitle:[coder decodeObjectOfClass:[NSString class] forKey:kMediaKeyTitle]];
        [self setSubtitle:[coder decodeObjectOfClass:[NSString class] forKey:kMediaKeySubtitle]];
        [self setDetails:[coder decodeObjectOfClass:[NSString class] forKey:kMediaKeyDetails]];
        [self setCoverUrl:[coder decodeObjectOfClass:[NSURL class] forKey:kMediaKeyCoverUrl]];
        [self setDuration:[coder decodeDoubleForKey:kMediaKeyDuration]];
        [self setElapsed:[coder decodeDoubleForKey:kMediaKeyElapsed]];
    }

    return self;
}

- (NSDictionary* _Nonnull const)jsonSerialize {
    return @{
        kMediaKeyApplicationBundleIdentifier: [self applicationBundleIdentifier],
        kMediaKeyIsPlaying: @([self isPlaying]),
        kMediaKeyTitle: [self title],
        kMediaKeySubtitle: [self subtitle] ? [self subtitle] : @"",
        kMediaKeyDetails: [self details] ? [self details] : @"",
        kMediaKeyCoverUrl: [self coverUrl] ? [self coverUrl] : @"",
        kMediaKeyDuration: @([self elapsed]),
        kMediaKeyElapsed: @([self duration])
    };
}
@end
