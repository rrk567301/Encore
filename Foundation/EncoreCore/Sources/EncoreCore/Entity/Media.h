//
//  Media.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

static NSString* _Nonnull const kMediaKeyApplicationBundleIdentifier = @"application_bundle_identifier";
static NSString* _Nonnull const kMediaKeyIsPlaying = @"is_playing";
static NSString* _Nonnull const kMediaKeyTitle = @"title";
static NSString* _Nonnull const kMediaKeySubtitle = @"subtitle";
static NSString* _Nonnull const kMediaKeyDetails = @"details";
static NSString* _Nonnull const kMediaKeyCoverUrl = @"cover_url";
static NSString* _Nonnull const kMediaKeyDuration = @"duration";
static NSString* _Nonnull const kMediaKeyElapsed = @"elapsed";

static NSString* _Nonnull const kMediaDefaultValueApplicationBundleIdentifier = @"";
static BOOL const kMediaDefaultValueIsPlaying = NO;
static NSString* _Nonnull const kMediaDefaultValueTitle = @"";
static NSString* _Nonnull const kMediaDefaultValueSubtitle = @"";
static NSString* _Nonnull const kMediaDefaultValueDetails = @"";
static CGFloat const kMediaDefaultValueDuration = 0;
static CGFloat const kMediaDefaultValueElapsed = 0;

@interface Media : NSObject <NSSecureCoding>
@property(nonatomic)NSString* _Nonnull applicationBundleIdentifier;
@property(nonatomic)BOOL isPlaying;
@property(nonatomic)NSString* _Nonnull title;
@property(nonatomic)NSString* _Nullable subtitle;
@property(nonatomic)NSString* _Nullable details;
@property(nonatomic)NSURL* _Nullable coverUrl;
@property(nonatomic, assign)CGFloat duration;
@property(nonatomic, assign)CGFloat elapsed;
- (BOOL)shouldBeCached;
- (NSDictionary* _Nonnull const)jsonSerialize;
@end
