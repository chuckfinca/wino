//
//  CustomNC.m
//  wineguide
//
//  Created by Charles Feinn on 11/23/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "CustomNC.h"
#import "ColorSchemer.h"

@interface CustomNC ()

@end

@implementation CustomNC

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
    self.navigationBar.barTintColor = [ColorSchemer sharedInstance].baseColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
