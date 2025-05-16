//
//  DiscordActivityFactory.mm
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <AppKit/AppKit.h>

#import "SPMDiscordRPC.h"

#import "./DiscordActivityFactory.hpp"
#import "../Entity/Media.h"

@implementation DiscordActivityFactory
- (DiscordRichPresence const)buildForMedia:(Media* _Nonnull const)media {
    [self padSingleLetterPropertiesForMedia:media];

    DiscordRichPresence activity{};
    activity.type = LISTENING;
    activity.displayType = DETAILS;
    activity.details = [[media title] UTF8String];
    activity.state = [[media subtitle] UTF8String];

    if ([media duration] > 0) {
        CGFloat const remainingTime = [media duration] - [media elapsed];
        activity.endTimestamp = time(nullptr) + (NSUInteger)remainingTime;
        activity.startTimestamp = time(nullptr) - (NSUInteger)[media elapsed];
    }

//    NSURL* _Nonnull const applicationUrl = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:[media applicationBundleIdentifier]];
//    NSBundle* _Nonnull const applicationBundle = [NSBundle bundleWithURL:applicationUrl];
//    NSString* _Nonnull const applicationDisplayName = [applicationBundle objectForInfoDictionaryKey:@"CFBundleExecutable"];

    NSRunningApplication* _Nonnull const application = [NSRunningApplication runningApplicationsWithBundleIdentifier:[media applicationBundleIdentifier]][0];
    NSString* _Nonnull const applicationDisplayName = [application localizedName];

    if ([media coverUrl]) {
        activity.largeImageKey = [[[media coverUrl] absoluteString] UTF8String];
        activity.largeImageText = [[media details] UTF8String];
        activity.smallImageKey = [@"appicon" UTF8String];
        activity.smallImageText = [applicationDisplayName UTF8String];
    } else {
        activity.largeImageKey = [@"appicon" UTF8String];
        activity.largeImageText = [applicationDisplayName UTF8String];
    }

//    activity.button1name = [@"Custom button" UTF8String];
//    activity.button1link = [@"" UTF8String];
//    activity.button2name = [@"Search on Odesli" UTF8String];
//    activity.button2link = [@"" UTF8String];

    return activity;
}

- (void)padSingleLetterPropertiesForMedia:(Media* _Nonnull const)media {
    if (1 == [[media title] length]) {
        [media setTitle:[[media title] stringByAppendingString:@" "]];
    }

    if (1 == [[media subtitle] length]) {
        [media setSubtitle:[[media subtitle] stringByAppendingString:@" "]];
    }

    if (1 == [[media details] length]) {
        [media setDetails:[[media details] stringByAppendingString:@" "]];
    }
}
@end
