//
//  DiscordActivityFactory.mm
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "SPMDiscordRPC.h"

#import "./DiscordActivityFactory.hpp"
#import "../Entity/Media.h"

@implementation DiscordActivityFactory
- (DiscordRichPresence const)buildForMedia:(Media* _Nonnull const)media {
    NSString* _Nonnull const nowPlayingApplicationDisplayName = [self localizedDisplayNameForNowPlayingApplicationWithBundleIdentifier:[media applicationBundleIdentifier]];

    DiscordRichPresence activity{};
    activity.type = LISTENING;
    activity.displayType = DETAILS;
    activity.details = [[self spacedStringFromString:[media title]] UTF8String];

    if ([media subtitle]) {
        activity.state = [[self spacedStringFromString:[media subtitle]] UTF8String];
    }

    if ([media duration] > 0) {
        CGFloat const remainingTime = [media duration] - [media elapsed];
        activity.endTimestamp = time(nullptr) + (NSUInteger)remainingTime;
        activity.startTimestamp = time(nullptr) - (NSUInteger)[media elapsed];
    }

    if ([media coverUrl]) {
        activity.largeImageKey = [[[media coverUrl] absoluteString] UTF8String];

        if ([media details]) {
            activity.largeImageText = [[self spacedStringFromString:[media details]] UTF8String];
        }

        activity.smallImageKey = [@"appicon" UTF8String];
        activity.smallImageText = [nowPlayingApplicationDisplayName UTF8String];
    } else {
        activity.largeImageKey = [@"appicon" UTF8String];
        activity.largeImageText = [nowPlayingApplicationDisplayName UTF8String];
    }

//    activity.button1name = [@"Custom button" UTF8String];
//    activity.button1link = [@"" UTF8String];
//    activity.button2name = [@"Search on Odesli" UTF8String];
//    activity.button2link = [@"" UTF8String];

    return activity;
}

- (NSString* _Nonnull const)spacedStringFromString:(NSString* _Nonnull const)string {
    NSString* _Nonnull paddedString = [string copy];

    if (1 == [paddedString length]) {
        paddedString = [paddedString stringByAppendingString:@" "];
    }

    return paddedString;
}

- (NSString* _Nonnull const)localizedDisplayNameForNowPlayingApplicationWithBundleIdentifier:(NSString* _Nonnull const)bundleIdentifier {
    NSRunningApplication* _Nonnull const application = [[NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier] firstObject];
    return [application localizedName];
}

- (NSString* _Nonnull const)literalDisplayNameForNowPlayingApplicationWithBundleIdentifier:(NSString* _Nonnull const)bundleIdentifier {
    NSURL* _Nonnull const applicationUrl = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:bundleIdentifier];
    NSBundle* _Nonnull const applicationBundle = [NSBundle bundleWithURL:applicationUrl];
    return [applicationBundle objectForInfoDictionaryKey:@"CFBundleExecutable"];
}
@end
