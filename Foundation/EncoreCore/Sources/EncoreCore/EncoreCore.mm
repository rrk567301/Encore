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
#import "./Provider/AppleScriptNowPlayingInfoProvider.h"
#import "./Provider/MediaRemoteNowPlayingInfoProvider.hpp"
#import "./Util/Logger.h"

@implementation EncoreCore
- (instancetype _Nonnull)init {
    self = [super init];

    if (self) {
        if (@available(macOS 15, *)) {
            _nowPlayingInfoProvider = [[AppleScriptNowPlayingInfoProvider alloc] init];
            [[Logger sharedInstance] logMessage:@"[Core] Using Apple Script provider" forType:LogTypeInfo];
        } else {
            _nowPlayingInfoProvider = [[MediaRemoteNowPlayingInfoProvider alloc] init];
            [[Logger sharedInstance] logMessage:@"[Core] Using Media Remote provider" forType:LogTypeInfo];
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
    if (Discord_IsConnected()) {
        return;
    }

    [[Logger sharedInstance] logMessage:@"[Core] Establishing connection to Discord" forType:LogTypeInfo];

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

- (void)disconnect {
    if (!Discord_IsConnected()) {
        return;
    }

    [[Logger sharedInstance] logMessage:@"[Core] Shutting down Discord connection" forType:LogTypeInfo];

    Discord_Shutdown();
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
    [[Logger sharedInstance] logMessage:[NSString stringWithFormat:@"[Core] Received new now playing info: %@", nowPlayingInfo] forType:LogTypeInfo];
    
    [self setMedia:nowPlayingInfo ? [_mediaFactory createForNowPlayingInfo:nowPlayingInfo] : nil];

    if (![self media] || ![[self media] isPlaying]) {
        [self disconnect];
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self connect];
        [self updateRichPresence];
    });
}

- (void)updateRichPresence {
    [[Logger sharedInstance] logMessage:@"[Core] Updating Rich Presence" forType:LogTypeInfo];

    DiscordRichPresence const activity = [_discordActivityFactory buildForMedia:[self media]];
    Discord_UpdatePresence(&activity);
}
@end
