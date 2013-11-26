//
//  SlidePanelsContainerViewController.m
//  SlideMenu
//
//  Created by Charles Feinn on 10/24/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "PanelsContainerViewController.h"
#import "MainPanelTabBarVC.h"
#import "SidePanelViewController.h"
#import "ColorSchemer.h"

#define MAIN_VC_TAG 1
#define LEFT_VC_TAG 2
#define RIGHT_VC_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 270

@interface PanelsContainerViewController () <MainPanelViewControllerDelegate, SidePanelViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MainPanelTabBarVC *mainPanelViewController;
@property (nonatomic, strong) SidePanelViewController *leftPanelViewController;
@property (nonatomic, strong) SidePanelViewController *rightPanelViewController;

@property (nonatomic) BOOL showingLeftPanel;
@property (nonatomic) BOOL showingRightPanel;
@property (nonatomic) BOOL showPanel;
@property (nonatomic) CGPoint preVelocity;


@end

@implementation PanelsContainerViewController

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
    [self setupView];
    NSLog(@"PanelsContainerViewController viewDidLoad");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self setupMainPanelFrame];
}


#pragma mark - Getters & Setters

-(MainPanelTabBarVC *)mainPanelViewController
{
    if(!_mainPanelViewController){
        NSString *storyboardName;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            storyboardName =  @"iPad";
        } else {
            storyboardName =  @"iPhone";
        }
        _mainPanelViewController = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateInitialViewController];
        _mainPanelViewController.view.tag = MAIN_VC_TAG;
        _mainPanelViewController.mainPanelViewDelegate = self;
    }
    return _mainPanelViewController;
}

#pragma mark - Setup View

-(void)setupView
{
    // set up center view
    [self.view addSubview:self.mainPanelViewController.view];
    [self addChildViewController:self.mainPanelViewController];
    [self.mainPanelViewController didMoveToParentViewController:self];
    
    [self setupMainPanelFrame];
    [self setupGestures];
}

-(void)setupMainPanelFrame
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation <= 2){
        self.mainPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        self.mainPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
}


- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    CALayer *layer = self.mainPanelViewController.view.layer;
    
    if(value){
        [layer setCornerRadius:CORNER_RADIUS];
        [layer setShadowColor:[ColorSchemer sharedInstance].shadowColor.CGColor];
        [layer setShadowOpacity:0.8];
        [layer setShadowOffset:CGSizeMake(offset, offset)];
    } else {
        [layer setCornerRadius:0.0f];
        [layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

-(UIView *)getLeftView
{
    if(!self.leftPanelViewController){
        
        // set up left panel
        NSLog(@"creating leftPanelViewController");
        self.leftPanelViewController = [[SidePanelViewController alloc] init];
        self.leftPanelViewController.view.tag = LEFT_VC_TAG;
        self.leftPanelViewController.delegate = self;
        
        [self.view addSubview:self.leftPanelViewController.view];
        [self addChildViewController:self.leftPanelViewController];
        [self.leftPanelViewController didMoveToParentViewController:self];
        
        self.leftPanelViewController.view.frame = CGRectMake(0, 0, self.mainPanelViewController.view.frame.size.width, self.mainPanelViewController.view.frame.size.height);
        self.leftPanelViewController.view.backgroundColor = [ColorSchemer sharedInstance].menuBackgroundColor;
        
        // set up view shadow
        [self showCenterViewWithShadow:YES withOffset:2];
    }
    return self.leftPanelViewController.view;
}

-(UIView *)getRightView
{
    if(!self.rightPanelViewController){
        
        // set up left panel
        NSLog(@"creating rightPanelViewController");
        self.rightPanelViewController = [[SidePanelViewController alloc] init];
        self.rightPanelViewController.view.tag = RIGHT_VC_TAG;
        self.rightPanelViewController.delegate = self;
        
        [self.view addSubview:self.rightPanelViewController.view];
        [self addChildViewController:self.rightPanelViewController];
        [self.rightPanelViewController didMoveToParentViewController:self];
        
        self.rightPanelViewController.view.frame = CGRectMake(0, 0, self.mainPanelViewController.view.frame.size.width, self.mainPanelViewController.view.frame.size.height);
        self.rightPanelViewController.view.backgroundColor = [ColorSchemer sharedInstance].menuBackgroundColor;
        
        // set up view shadow
        [self showCenterViewWithShadow:YES withOffset:2];
    }
    return self.rightPanelViewController.view;
}

-(void)resetPanels
{
    NSLog(@"resetPanels...");
    [self.leftPanelViewController.view removeFromSuperview];
    self.leftPanelViewController = nil;
    
    self.showingLeftPanel = NO;
    self.mainPanelViewController.leftButton.tag = 1;
    
    [self.rightPanelViewController.view removeFromSuperview];
    self.rightPanelViewController = nil;
    
    self.showingRightPanel = NO;
    self.mainPanelViewController.rightButton.tag = 1;
    
    
    // reset view shadow
    [self showCenterViewWithShadow:NO withOffset:0];
}


#pragma mark - Delegate Actions

- (void)movePanelLeft // to show right panel
{
    NSLog(@"PCVC - movePanelLeft");
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainPanelViewController.view.frame = CGRectMake(-PANEL_WIDTH, 0, self.mainPanelViewController.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if(finished){
            self.mainPanelViewController.rightButton.tag = 0;
        }
    }];
    
    self.showingLeftPanel = YES;
}

- (void)movePanelRight // to show left panel
{
    NSLog(@"PCVC - movePanelRight");
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainPanelViewController.view.frame = CGRectMake(PANEL_WIDTH, 0, self.mainPanelViewController.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if(finished){
            self.mainPanelViewController.leftButton.tag = 0;
        }
    }];
    
    self.showingRightPanel = YES;
}

- (void)movePanelToOriginalPosition
{
    NSLog(@"PCVC - movePanelToOriginalPosition");
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self setupMainPanelFrame];
    } completion:^(BOOL finished) {
        if(finished){
            [self resetPanels];
        }
    }];
}

#pragma mark - Gestures

- (void)setupGestures
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    panGesture.delegate = self;
    
    [self.mainPanelViewController.view addGestureRecognizer:panGesture];
}

-(void)movePanel:(UIPanGestureRecognizer *)panGesture
{
    //[panGesture.view.layer removeAllAnimations];
    
    CGPoint velocity = [panGesture velocityInView:panGesture.view];
    CGPoint translatedPoint = [panGesture translationInView:self.view];
    
    if([panGesture state] == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan...");
        
        UIView __weak *childView = nil;
        
        if(velocity.x > 0){
            if(!self.showingRightPanel){
                NSLog(@"getLeftView");
                childView = [self getLeftView];
            }
        } else {
            if(!self.showingLeftPanel){
                NSLog(@"getRightView");
                childView = [self getRightView];
            }
        }
        
        // make sure the view you're working with is front and center
        [self.view sendSubviewToBack:childView];
        [panGesture.view bringSubviewToFront:[panGesture view]];
        
        /*
         self.beginningOrigin = self.mainPanelViewController.view.frame.origin.x;
         NSLog(@"beginning origin = %f",self.beginningOrigin);
         
         self.beginningCenter = self.mainPanelViewController.view.center.x;
         NSLog(@"beginning center = %f",self.beginningCenter);
         */
    }
    
    if([panGesture state] == UIGestureRecognizerStateEnded){
        NSLog(@"UIGestureRecognizerStateEnded...");
        
        float originX = self.mainPanelViewController.view.frame.origin.x;
        
        if(!self.showingLeftPanel && !self.showingRightPanel){
            if(originX <= -(PANEL_WIDTH/2)){
                NSLog(@"movePanelLeft");
                [self movePanelLeft];
            } else if (originX >=PANEL_WIDTH/2){
                NSLog(@"movePanelRight");
                [self movePanelRight];
            } else {
                [self movePanelToOriginalPosition];
            }
        } else {
            [self movePanelToOriginalPosition];
        }
        
        /*
         NSLog(@"translatedPoint.x = %f",translatedPoint.x);
         NSLog(@"origin.x = %f",originX);
         NSLog(@"center = %f",self.mainPanelViewController.view.center.x);
         NSLog(@"delta origin = %f",self.beginningOrigin - self.mainPanelViewController.view.frame.origin.x);
         NSLog(@"delta center = %f",self.beginningCenter - self.mainPanelViewController.view.center.x);
         NSLog(@"self.showingLeftPanel = %i",self.showingLeftPanel);
         NSLog(@"showingRightPanel = %i",self.showingRightPanel);
         */
    }
    
    if([panGesture state] == UIGestureRecognizerStateChanged){
        
        translatedPoint = [panGesture translationInView:self.view];
        
        // allow dragging only in x-coordinates by only updating the x-coordinate with translation position
        float newX = panGesture.view.center.x + translatedPoint.x;
        
        NSLog(@"panGesture class = %@",[panGesture class]);
        
        if(self.leftPanelViewController && panGesture.view.center.x < self.mainPanelViewController.view.frame.size.width/2) {
            newX = panGesture.view.center.x;
        }
        if(self.rightPanelViewController && panGesture.view.center.x > self.mainPanelViewController.view.frame.size.width/2){
            newX = panGesture.view.center.x;
        }
        
        panGesture.view.center = CGPointMake(newX, panGesture.view.center.y);
        
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    
}

@end
