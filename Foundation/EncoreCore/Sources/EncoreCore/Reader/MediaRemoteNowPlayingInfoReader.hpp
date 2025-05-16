//
//  MediaRemoteNowPlayingInfoReader.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./NowPlayingInfoReaderProtocol.h"

@interface MediaRemoteNowPlayingInfoReader : NSObject <NowPlayingInfoReaderProtocol> {
    NSDictionary* _Nullable _nowPlayingInfo;
}
@end
