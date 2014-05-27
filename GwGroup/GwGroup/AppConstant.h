//
//  AppConstant.h
//  GwGroup
//
//  Created by gao wenjian on 14-1-13.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#ifndef GwGroup_AppConstant_h
#define GwGroup_AppConstant_h

#define SEARCH @"api.openweathermap.org/data/2.5/find?q=London&units=metric&mode=xml"

#define ROOT_FORECAST_SIXHOUR_URL @"http://api.openweathermap.org/data/2.5/forecast"

#define ROOT_FORECAST_URL @"http://api.openweathermap.org/data/2.5/forecast/daily"

#define ROOT_CURWEATHER_URL @"http://api.openweathermap.org/data/2.5/weather"

#define WEAHTER_STATU_IMAGE_URL @"http://openweathermap.org/img/w"

#define DB_NAME @"db" 
#define DB_EXT @".sqlite3"

#if 1
#define GWLog(s,...)NSLog(@"<%p %@:(%d)> %@",self,[[NSString stringWithUTF8String:__FILE__]lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__])
#else
#define GWLog(s,...)
#endif

//iphone5判断
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//ios 7
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)

#define SYSTEMOSVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define NSUSER_DEFUALT [NSUserDefaults standardUserDefaults]

#define LOCATION [NSUSER_DEFUALT objectForKey:CURPLACE]

/**** tips *****/
#define REQUEST_FAIL @"请求失败,请稍后再试!"


/**** constants *****/
#define CURPLACE @"CURPLACE"
#define LATITU @"LATITU"
#define LONGITU @"LONGITU"
#define LOCATION_NOTIF_NAME @"LocaSuccess"

#define APP_WEATHER_ID @"372c9df12862eb4d8f0b9903ec961bc0"
#endif
