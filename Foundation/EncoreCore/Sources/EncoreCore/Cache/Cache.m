//
//  Cache.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher and Spotify
//

#import "SPMSPTPersistentCache.h"
#import "./Cache.h"

@implementation Cache
+ (instancetype _Nonnull const)sharedInstance {
    static Cache* sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [Cache alloc];

        NSString* _Nonnull const cacheIdentifier = [NSString stringWithFormat:@"%@.track.cache", [[NSBundle mainBundle] bundleIdentifier]];

        SPTPersistentCacheOptions* _Nonnull const options = [[SPTPersistentCacheOptions alloc] init];
        [options setCachePath:[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject], cacheIdentifier]];
        [options setCacheIdentifier:cacheIdentifier];
        [options setDefaultExpirationPeriod:60 * 60 * 24 * 30]; // 30 days
        [options setGarbageCollectionInterval:(NSUInteger)(1.5 * SPTPersistentCacheDefaultGCIntervalSec)];
        [options setSizeConstraintBytes:1024 * 1024 * 10]; // 10 MiB

        SPTPersistentCache* _Nonnull const cache = [[SPTPersistentCache alloc] initWithOptions:options];
        [cache scheduleGarbageCollector];

        sharedInstance->_cache = cache;
    });

    return sharedInstance;
}

- (instancetype _Nonnull const)init {
    return [Cache sharedInstance];
}

- (void)writeData:(NSData* _Nonnull const)data forKey:(NSString* _Nonnull const)key {
    [_cache storeData:data forKey:key locked:NO withCallback:nil onQueue:dispatch_get_main_queue()];
}

- (NSData* _Nullable const)readDataForKey:(NSString* _Nonnull const)key  {
    dispatch_group_t const sync = dispatch_group_create();
    dispatch_group_enter(sync);

    __block NSData* _Nullable data = nil;
    [_cache loadDataForKey:key withCallback:^(SPTPersistentCacheResponse* cacheResponse) {
        data = [[cacheResponse record] data];
        dispatch_group_leave(sync);
    } onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];

    dispatch_group_wait(sync, DISPATCH_TIME_FOREVER);

    return data;
}
@end
