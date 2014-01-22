//
//  GwUtil.m
//  GwGroup
//
//  Created by gao wenjian on 14-1-13.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#import "GwUtil.h"
#import "GwDbHelper.h"
@implementation GwUtil

+ (void)loadWorldId
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chinaplaces" ofType:@"txt"]];
    NSString *place = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *linerArray = [place componentsSeparatedByString:@"\n"];

    GwDbHelper *helper = [GwDbHelper dbShareInstant];
    [helper openDb];
    
    for (NSString *str in linerArray) {
        NSArray *oneLiner = [str componentsSeparatedByString:@"\t"];
        char *update = "INSERT OR REPLACE INTO FAVOURITES (NEWSID, TITLE, SAVE_TIME) VALUES (?, ?, ?);";
    }
    
    [helper closeDb];
}

@end
