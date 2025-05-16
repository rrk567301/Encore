//
//  NSString+xxHash.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "SPMxxHash.h"
#import "./NSString+xxHash.h"

@implementation NSString (xxHash)
- (NSString* _Nonnull const)xxh64 {
    const char* _Nonnull const cStr = [self UTF8String];
    size_t length = strlen(cStr);

    XXH64_hash_t hash = XXH64(cStr, length, 0);

    return [NSString stringWithFormat:@"%016llx", hash];
}
@end
