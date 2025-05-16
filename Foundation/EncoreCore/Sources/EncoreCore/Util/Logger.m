//
//  Logger.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "Logger.h"

@implementation Logger
+ (instancetype _Nonnull const)sharedInstance {
    static Logger* _Nonnull sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [Logger alloc];
        sharedInstance->_fileManager = [NSFileManager defaultManager];
        sharedInstance->_logsPath = [sharedInstance logsPath];
    });

    return sharedInstance;
}

- (instancetype _Nonnull const)init {
    return [Logger sharedInstance];
}

- (void)logMessage:(NSString* _Nonnull const)message forType:(LogType)type {
    NSString* _Nonnull const logIndicator = [self indicatorForLogType:type];
    NSString* _Nonnull const logDate = [self currentDateWithFormat:kLogDateFormatLogMessage];
    NSString* _Nonnull logMessage = [NSString stringWithFormat:@"%@ %@ | %@", logIndicator, logDate, message];

    #if DEBUG
        [self logToConsole:logMessage];
    #endif

    [self logToFile:logMessage];
}

- (void)logToConsole:(NSString* _Nonnull const)logMessage {
    NSLog(@"%@", logMessage);
}

- (void)logToFile:(NSString* _Nonnull)logMessage {
    [self ensureFileSystem];

    logMessage = [logMessage stringByAppendingString:@"\n"];

    NSString* _Nonnull const logFilePath = [self logFilePath];
    NSData* _Nonnull const logMessageData = [logMessage dataUsingEncoding:NSUTF8StringEncoding];

    NSFileHandle* _Nonnull const fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    if (fileHandle) {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:logMessageData];
        [fileHandle closeFile];
    } else {
        NSError* _Nullable error = nil;
        [logMessage writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

        if (error) {
            NSLog(@"Error creating log file: %@", [error localizedDescription]);
        }
    }
}

- (void)ensureFileSystem {
    if (![_fileManager fileExistsAtPath:_logsPath]) {
        NSError* _Nullable error = nil;
        [_fileManager createDirectoryAtPath:_logsPath withIntermediateDirectories:YES attributes:nil error:&error];

        if (error) {
            NSLog(@"Error creating logs directory: %@", [error localizedDescription]);
        }
    }
}

- (NSString* _Nonnull const)indicatorForLogType:(LogType)type {
    switch (type) {
        case LogTypeInfo:
            return @"[*]";
        case LogTypeWarning:
            return @"[#]";
        case LogTypeError:
            return @"[!]";
    }
}

- (NSString* _Nonnull const)currentDateWithFormat:(NSString* _Nonnull const)format {
    NSDateFormatter* _Nonnull const dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSString* _Nonnull const)logFilePath {
    return [NSString stringWithFormat:@"%@%@.log", _logsPath, [self currentDateWithFormat:kLogDateFormatFileName]];
}

- (NSString* _Nonnull const)logsPath {
    NSArray* _Nonnull const paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/Logs/%@/", [paths firstObject], [[NSBundle mainBundle] bundleIdentifier]];
}
@end
