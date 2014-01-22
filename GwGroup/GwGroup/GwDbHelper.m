//
//  GwDbHelper.m
//  GwGroup
//
//  Created by gao wenjian on 14-1-22.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwDbHelper.h"


@implementation GwDbHelper
@synthesize dbObj = _dbObj;

static GwDbHelper *helper = nil;

+ (GwDbHelper *)dbShareInstant
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!helper) {
            helper = [[self alloc] init];
        }
    });
    return helper;
}

- (id)init
{
    self = [super init];
    if (self) {
    
        [self createTable];
        
    }
    return self;
}

- (void)createTable
{
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FAVOURITES (woeId TEXT , iso TEXT, name TEXT,language TEXT,placetype TEXT,parentId TEXT);";
    
    [self runSql:createSQL];
}



- (void)runSql:(NSString *)sql
{
    [self openDb];
    
    if (sqlite3_exec(_dbObj, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
        sqlite3_close(_dbObj);
    }
}

- (void)openDb
{
    [self copyDbFileDomain];
    
    int result = sqlite3_open([[self dbFilePath] UTF8String], &_dbObj);
    if (result != SQLITE_OK) {
        NSAssert(0, @"open db fail");
    }
}

- (void)closeDb
{
    if (_dbObj) {
        int result = sqlite3_close(_dbObj);
        if (result != SQLITE_OK) {
            NSAssert(0, @"close db fail");
        }
    }
}

- (void)copyDbFileDomain
{
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL exit = [manger fileExistsAtPath:[self dbFilePath]];
    if (!exit) {
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", DB_NAME, DB_EXT]];
        [manger copyItemAtPath:path toPath:[self dbFilePath] error:NULL];
    }
}

/**
 *  db文件放到cache目录
 *
 *  @return db 存放路径
 */
- (NSString *)dbFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", DB_NAME, DB_EXT]];
	return path;
}
@end
