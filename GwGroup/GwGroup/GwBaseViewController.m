//
//  GwBaseViewController.m
//  GwGroup
//
//  Created by gao wenjian on 14-1-13.
//  Copyright (c) 2014年 gao wenjian. All rights reserved.
//

#import "GwBaseViewController.h"
#import "GwUtil.h"
#import "AFNetworking.h"

@interface GwBaseViewController ()

@end

@implementation GwBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)testAf
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger POST:@""
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
         }];
}
@end
