//
//  GwAppDelegate.h
//  GwGroup
//
//  Created by gao wenjian on 14-1-13.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GwLocationManager.h"

@interface GwAppDelegate : UIResponder <UIApplicationDelegate,LocationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
