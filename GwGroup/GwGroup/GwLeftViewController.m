//
//  GwLeftViewController.m
//  GwGroup
//
//  Created by gao wenjian on 14-5-8.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwLeftViewController.h"
#import "GwSearchViewController.h"
@interface GwLeftViewController ()

@end

@implementation GwLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)editCity
{

}

- (void)addCity
{
    GwSearchViewController *search = [[GwSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:search];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"City"];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCity)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCity)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
