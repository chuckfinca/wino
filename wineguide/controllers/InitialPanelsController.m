//
//  InitialPanelsController.m
//  Gimme
//
//  Created by Charles Feinn on 11/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "InitialPanelsController.h"
#import "DocumentHandler.h"
#import "LocalObjectUpdater.h"
#import "MainTabBarController.h"
#import "ColorSchemer.h"
#import "TutorialVC.h"
#import "UserMenuVC.h"

#define SUPRESS_TUTORIAL @"ShowTutorial"

@interface InitialPanelsController ()

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) TutorialVC *tutorialVC;
@property (nonatomic) BOOL supressTutorial;

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
    // [[ColorSchemer sharedInstance] mixItUp]; // use to check that colors are being set by ColorSchemer throughout the app
    
    [self setupViewControllers];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupDocument];
    
    if(self.supressTutorial == NO) {
        [self setupTutorial];
    }
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
        [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
            self.document = document;
            self.context = document.managedObjectContext;
            // Do any additional work now that the document is ready
            [self updateLocalObjects];
            MainTabBarController *mtbc = (MainTabBarController *)self.mainPanelViewController;
            mtbc.context = document.managedObjectContext;
        }];
    }
}

-(void)updateLocalObjects
{
    LocalObjectUpdater *lou = [[LocalObjectUpdater alloc] init];
    lou.context = self.context;
    [lou updateTastingNotesAndVarietals];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




@end
