//
//  ItunesCoverFetcher.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "../Entity/Media.h"
#import "./ItunesCoverFetcher.h"
#import "../Util/Logger.h"

@implementation ItunesCoverFetcher
- (NSURL* _Nullable const)fetchCoverUrlForMedia:(Media* _Nonnull const)media {
    NSURL* _Nonnull const endpointUrl = [self constructEndpointUrlForMedia:media];
    
    [[Logger sharedInstance] logMessage:[NSString stringWithFormat:@"[Core] Fetching cover using the iTunes API with URL: %@", endpointUrl] forType:LogTypeInfo];

    dispatch_group_t const sync = dispatch_group_create();
    dispatch_group_enter(sync);

    __block NSURL* _Nullable coverUrl = nil;
    NSURLSessionDataTask* _Nonnull const task = [[NSURLSession sharedSession] dataTaskWithURL:endpointUrl completionHandler:^(NSData* _Nullable const data, NSURLResponse* _Nullable const response, NSError* _Nullable error) {
        if (error) {
            dispatch_group_leave(sync);
            return;
        }

        NSDictionary* _Nullable const json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            dispatch_group_leave(sync);
            return;
        }

        NSArray* _Nonnull const results = json[@"results"];
        if ([results count] > 0) {
            coverUrl = [NSURL URLWithString:results[0][@"artworkUrl100"]];
            dispatch_group_leave(sync);
            return;
        }

        dispatch_group_leave(sync);
    }];

    [task resume];
    dispatch_group_wait(sync, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC));

    return coverUrl;
}

- (NSURL* _Nonnull const)constructEndpointUrlForMedia:(Media* _Nonnull const)media {
    NSString* _Nonnull queryParameter = [media title];

    if ([media subtitle]) {
        queryParameter = [NSString stringWithFormat:@"%@ %@", queryParameter, [media subtitle]];
    }

    if ([media details]) {
        queryParameter = [NSString stringWithFormat:@"%@ %@", queryParameter, [media details]];
    }

    // The iTunes API doesn't return any result if "*" is contained.
    queryParameter = [queryParameter stringByReplacingOccurrencesOfString:@"*" withString:@""];

    queryParameter = [queryParameter stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    return [NSURL URLWithString:[@"https://itunes.apple.com/search?media=music&entity=song&term=" stringByAppendingString:queryParameter]];
}
@end
