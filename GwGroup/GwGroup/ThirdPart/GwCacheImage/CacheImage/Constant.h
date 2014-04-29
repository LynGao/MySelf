//
//  Constant.h
//  BlockTest
//
//  Created by gao wenjian on 13-7-31.
//  Copyright (c) 2013年 isoftstone. All rights reserved.
//

#ifndef BlockTest_Constant_h
#define BlockTest_Constant_h

#define RESETDETAILIMAGEVIEW @"RESETDETAILIMAGEVIEW"
#define HIDDENTOOLBAR @"HIDDENTOOLBAR"
#define GWIMAGEMANAGER_DELEGATE @"GWIMAGEMANAGER_DELEGATE"
#define GWIMAGEMANAGER_URL @"GWIMAGEMANAGER_URL"
#define GWIMAGEMANAGER_SHOWLOADINGFLAG @"GWIMAGEMANAGER_SHOWLOADINGFLAG"
#define GWIMAGEMANAGER_CACHEENABLE @"GWIMAGEMANAGER_CACHEENABLE"


#define GWJLog(s,...)NSLog(@"<%p %@:(%d)>%@",self,[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__])

#define GwFileManager [NSFileManager defaultManager]


/*************** processView 转圈颜色定义  ****************/
#define PROCESSVIEW_CICLE_COLOR_R 88.0
#define PROCESSVIEW_CICLE_COLOR_G 188.0
#define PROCESSVIEW_CICLE_COLOR_B 150.0
#define PROCESSVIEW_LINER_WIDTH 2 //线条的宽度

#endif
