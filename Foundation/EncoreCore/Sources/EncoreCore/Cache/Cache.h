//
//  Cache.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Cache : NSObject {
    sqlite3* _Nonnull _database;
    NSString* _Nonnull _databaseFilePath;
}
+ (instancetype _Nonnull)sharedInstance;
@end
