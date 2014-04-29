//
//  GwLocationManager.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-18.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationDelegate <NSObject>

- (void)locationSuccess:(NSString *)city;

- (void)locationFail:(NSString *)errorString;

@end

@interface GwLocationManager : NSObject

@property (nonatomic, assign) id<LocationDelegate> delegate;

+ (GwLocationManager *)shareLocationManger;

- (void)startLocation;
@end
