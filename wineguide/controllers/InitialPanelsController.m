//
//  InitialPanelsController.m
//  Gimme
//
//  Created by Charles Feinn on 11/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "InitialPanelsController.h"
#import "UserMenuVC.h"

@interface InitialPanelsController ()

@end

@implementation InitialPanelsController

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
    [self setupViewControllers];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupViewControllers
{
    NSString *storyboardName;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        storyboardName =  @"iPad";
    } else {
        storyboardName =  @"iPhone";
    }
    self.mainPanelViewController = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateInitialViewController];
    self.leftPanelViewController = [[UserMenuVC alloc] initWithNibName:@"UserMenu" bundle:nil];
    self.rightPanelViewController = [[UIViewController alloc] init];
}

@end
