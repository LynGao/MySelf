//
//  GwBaseBi.h
//  GwGroup
//
//  Created by gao wenjian on 14-4-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetDataFinish)(id callBackData);

typedef void(^GetDataFail)(id errorMsg);

@interface GwBaseBi : NSObject

@property (nonatomic, strong) GetDataFinish finishBlock;

@property (nonatomic, strong) GetDataFail failBlock;

@end
