//
//  Media.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@interface Media : NSObject
@property(nonatomic)NSString* _Nonnull applicationBundleIdentifier;
@property(nonatomic, assign)BOOL isPlaying;
@property(nonatomic)NSString* _Nonnull title;
@property(nonatomic)NSString* _Nullable subtitle;
@property(nonatomic)NSString* _Nullable details;
@property(nonatomic)NSURL* _Nullable const coverUrl;
@property(nonatomic, assign)CGFloat duration;
@property(nonatomic, assign)CGFloat elapsed;
@end
