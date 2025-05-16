//
//  Media.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

static NSString* _Nonnull const kMediaDefaultValueApplicationBundleIdentifier = @"";
static BOOL const kMediaDefaultValueIsPlaying = NO;
static NSString* _Nonnull const kMediaDefaultValueTitle = @"";
static NSString* _Nonnull const kMediaDefaultValueSubtitle = @"";
static NSString* _Nonnull const kMediaDefaultValueDetails = @"";
static CGFloat const kMediaDefaultValueDuration = 0;
static CGFloat const kMediaDefaultValueElapsed = 0;

@interface Media : NSObject
@property(nonatomic)NSString* _Nonnull applicationBundleIdentifier;
@property(nonatomic, assign)BOOL isPlaying;
@property(nonatomic)NSString* _Nonnull title;
@property(nonatomic)NSString* _Nullable subtitle;
@property(nonatomic)NSString* _Nullable details;
@property(nonatomic)NSURL* _Nullable const coverUrl;
@property(nonatomic, assign)CGFloat duration;
@property(nonatomic, assign)CGFloat elapsed;
- (NSDictionary* _Nonnull const)jsonSerialize;
@end
