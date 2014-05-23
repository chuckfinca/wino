//
//  InitialTabBarController.m
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "MainTabBarController.h"
#import "TutorialVC.h"
#import "DocumentHandler2.h"
#import "ColorSchemer.h"

#define SUPRESS_TUTORIAL @"ShowTutorial"

@interface MainTabBarController () <UIAlertViewDelegate>

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) TutorialVC *tutorialVC;
@property (nonatomic) BOOL supressTutorial;
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
    [self setupDocument];
    
    if(self.supressTutorial == NO) {
        [self setupTutorial];
    }
    
    self.view.tintColor = [ColorSchemer sharedInstance].clickable;
    self.selectedIndex = 1;
}

#pragma mark - Getters & Setters

-(BOOL)supressTutorial
{
    if(!_supressTutorial) {
        _supressTutorial = [[[NSUserDefaults standardUserDefaults] valueForKey:SUPRESS_TUTORIAL] boolValue];
    }
    return _supressTutorial;
}

#pragma mark - Setup

-(void)setupTutorial
{
    self.tutorialVC = [[TutorialVC alloc] init];
    [self.view addSubview:self.tutorialVC.view];
    [self.view bringSubviewToFront:self.tutorialVC.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissTutorial:)
                                                 name:@"Dismiss Tutorial"
                                               object:nil];
}

-(void)setupDocument
{
    if(!self.document){
        [[DocumentHandler2 sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            self.document = document;
            self.context = document.managedObjectContext;
        }];
    }
}

#pragma mark - Tutorial

-(void)dismissTutorial:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tutorialVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tutorialVC.view removeFromSuperview];
        self.tutorialVC = nil;
        [self disableIntro];
    }];
}

-(void)disableIntro
{
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:SUPRESS_TUTORIAL];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
