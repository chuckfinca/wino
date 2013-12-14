//
//  InitialTabBarController.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "MainTabBarController.h"
#import "ColorSchemer.h"

#define SUPRESS_TUTORIAL @"ShowTutorial"

@interface MainTabBarController () <UIAlertViewDelegate>

@property (nonatomic) BOOL locationServicesEnabled;

@end

@implementation MainTabBarController

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
    self.view.tintColor = [ColorSchemer sharedInstance].baseColor;
    self.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
