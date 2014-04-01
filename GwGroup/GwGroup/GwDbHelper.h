//
//  GwDbHelper.h
//  GwGroup
//
//  Created by gao wenjian on 14-1-22.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
/**
 *  单线程时候，可以用单例。
 *  多线程，则需要新开方法。
 */


@interface GwDbHelper : NSObject
{
    sqlite3 *_dbObj;
}

@property (nonatomic, readonly) sqlite3 *dbObj;// read only 

+ (GwDbHelper *)dbShareInstant;

- (void)openDb;

- (void)closeDb;

/**
 *  拷贝db文件到沙盒
 */
- (void)copyDbFileDomain;

- (BOOL)checkDbFile;
@end
