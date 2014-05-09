//
//  GwSearchViewController.m
//  GwGroup
//
//  Created by gao wenjian on 14-5-9.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "GwSearchViewController.h"

@interface GwSearchViewController ()<UISearchBarDelegate>
{
   IBOutlet UISearchBar *_searchBar;
}
@end

@implementation GwSearchViewController

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
    [_searchBar setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

#pragma mark -- searchbar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

@end
