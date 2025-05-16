//
//  ItunesCoverFetcher.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@class Media;

@interface ItunesCoverFetcher : NSObject
- (NSURL* _Nullable const)fetchCoverUrlForMedia:(Media* _Nonnull const)media;
@end
