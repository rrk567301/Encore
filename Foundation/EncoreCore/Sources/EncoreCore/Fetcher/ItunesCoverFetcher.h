//
//  ItunesCoverFetcher.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@class Media;

static NSString* _Nonnull const kItunesApiEndpoint = @"https://itunes.apple.com/search?media=music&entity=song&term=";
static NSString* _Nonnull const kItunesApiEndpointKeyResults = @"results";
static NSString* _Nonnull const kItunesApiEndpointKeyArtworkUrl100 = @"artworkUrl100";

@interface ItunesCoverFetcher : NSObject
- (NSURL* _Nullable const)fetchCoverUrlForMedia:(Media* _Nonnull const)media;
@end
