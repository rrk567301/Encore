//
//  EncoreCore.mm
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "SPMDiscordRPC.h"

#import "./EncoreCore.hpp"
#import "./Entity/Media.h"
#import "./Factory/DiscordActivityFactory.hpp"
#import "./Factory/MediaFactory.h"
#import "./Reader/AppleScriptNowPlayingInfoReader.h"
#import "./Reader/MediaRemoteNowPlayingInfoReader.hpp"

@implementation EncoreCore
- (instancetype _Nonnull)init {
    self = [super init];

    if (self) {
        if (@available(macOS 15, *)) {
            _nowPlayingInfoReader = [[AppleScriptNowPlayingInfoReader alloc] init];
        } else {
            _nowPlayingInfoReader = [[MediaRemoteNowPlayingInfoReader alloc] init];
        }
        _mediaFactory = [[MediaFactory alloc] init];
        _discordActivityFactory = [[DiscordActivityFactory alloc] init];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self runCallbacks];
        });

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoChanged:) name:kNotificationNameNowPlayingInfoChanged object:nil];
    }

    return self;
}

- (void)connect {
    NSString* _Nullable clientId = kClientIdNone;
    for (;;) {
        clientId = [self getClientId];
        if (kClientIdNone != clientId) {
            break;
        }
        sleep(kTimeoutReconnect);
    }

    for (;;) {
        DiscordEventHandlers discordHandler{};
        Discord_Initialize([clientId UTF8String], &discordHandler);
        if (Discord_IsConnected()) {
            break;
        }
        sleep(kTimeoutReconnect);
    }
}

- (void)runCallbacks {
    for (;;) {
        Discord_RunCallbacks();
        sleep(kTimeoutCallback);
    }
}

- (NSString *)getClientId {
    return @"1370300288212144188";
}

- (void)nowPlayingInfoChanged:(NSNotification* _Nonnull const)notification {
    NSDictionary* _Nullable const nowPlayingInfo = [notification userInfo];
    [self setMedia:nowPlayingInfo ? [_mediaFactory createForNowPlayingInfo:nowPlayingInfo] : nil];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self media] || ![[self media] isPlaying]) {
            if (Discord_IsConnected()) {
                Discord_Shutdown();
            }
            return;
        }

        if (!Discord_IsConnected()) {
            [self connect];
        }

        [self updateRichPresence];
    });
}

- (void)updateRichPresence {
    DiscordRichPresence const activity = [_discordActivityFactory buildForMedia:[self media]];
    Discord_UpdatePresence(&activity);
}
@end
