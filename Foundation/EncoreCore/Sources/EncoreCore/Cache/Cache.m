//
//  Cache.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "Cache.h"

@implementation Cache
+ (instancetype _Nonnull)sharedInstance {
    static Cache* _Nonnull sharedInstance = nil;
    static dispatch_once_t onceToken = 0;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[Cache alloc] init];
    });

    return sharedInstance;
}

- (instancetype _Nonnull)init {
    self = [super init];

    if (self) {
        [self openDatabase];
        [self prepareTables];
    }

    return self;
}

- (void)openDatabase {
    NSString* applicationSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString* path = [applicationSupportPath stringByAppendingPathComponent:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
    _databaseFilePath = [path stringByAppendingPathComponent:@"cache.sqlite"];

    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

    if (SQLITE_OK != sqlite3_open([_databaseFilePath UTF8String], &_database)) {
        NSLog(@"db not open");
    }
}

- (void)prepareTables {
    const char* sql = "CREATE TABLE IF NOT EXISTS itunes_tracks (id INT PRIMARY KEY);";
    char* errorMessage = NULL;
    if (SQLITE_OK != sqlite3_exec(_database, sql, NULL, NULL, &errorMessage)) {
        NSLog(@"%s", errorMessage);
    }
}

- (void)dealloc {
    sqlite3_close(_database);
}
@end
