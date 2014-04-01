//
//  AppConstant.h
//  GwGroup
//
//  Created by gao wenjian on 14-1-13.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#ifndef GwGroup_AppConstant_h
#define GwGroup_AppConstant_h

#define DB_NAME @"db" 
#define DB_EXT @".sqlite3"

#if 1
#define GWLog(s,...)NSLog(@"<%p %@:(%d)> %@",self,[[NSString stringWithUTF8String:__FILE__]lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__])
#else
#define GWLog(s,...)
#endif

#endif
