//
//  MediaFactory.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@class ItunesCoverFetcher;
@class Media;

@interface MediaFactory : NSObject {
    ItunesCoverFetcher* _Nonnull _itunesCoverFetcher;
}
- (Media* _Nonnull const)createForNowPlayingInfo:(NSDictionary* _Nonnull const)nowPlayingInfo;
@end
