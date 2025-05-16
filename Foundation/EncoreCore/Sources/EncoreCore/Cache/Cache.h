//
//  Cache.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@class SPTPersistentCache;

@interface Cache : NSObject {
    SPTPersistentCache* _Nonnull _cache;
}
+ (instancetype _Nonnull const)sharedInstance;
- (void)writeData:(NSData* _Nonnull const)data forKey:(NSString* _Nonnull const)key;
- (NSData* _Nullable const)dataForKey:(NSString* _Nonnull const)key;
@end
