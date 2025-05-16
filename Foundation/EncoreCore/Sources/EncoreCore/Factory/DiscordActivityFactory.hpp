//
//  DiscordActivityFactory.hpp
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@class Media;

@interface DiscordActivityFactory : NSObject
- (DiscordRichPresence const)buildForMedia:(Media* _Nonnull const)media;
@end
