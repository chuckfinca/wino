//
//  SlidePanelsContainerViewController.m
//  SlideMenu
//
//  Created by Charles Feinn on 10/24/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "PanelsContainerViewController.h"

#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 270

NSString * const RightSideBoundary = @"RightSideBoundary";
NSString * const LeftSideBoundary = @"LeftSideBoundary";


#define SHOW_OR_HIDE_LEFT_PANEL @"ShowHideLeftPanel"

@interface PanelsContainerViewController () <UIGestureRecognizerDelegate, UICollisionBehaviorDelegate>

@property (nonatomic) BOOL showPanel;
@property (nonatomic) CGPoint preVelocity;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic) CGPoint anchorPoint;

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHideLeftPanel:) name:SHOW_OR_HIDE_LEFT_PANEL object:nil];
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
    [self movePanelToOriginalPosition];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Setters & Getters

-(UIDynamicAnimator *)dynamicAnimator
{
    if(!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.window];
    }
    return _dynamicAnimator;
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


- (void)showCenterViewWithShadow:(BOOL)value
{
    CALayer *layer = self.mainPanelViewController.view.layer;
    
    if(value){
        [layer setCornerRadius:CORNER_RADIUS];
        [layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor];
        [layer setShadowOpacity:0.8];
    } else {
        [layer setCornerRadius:0.0f];
    }
}

-(UIView *)prepareViewForSidePanelVC:(UIViewController *)sideViewController
{
    
    [self.view addSubview:sideViewController.view];
    [self addChildViewController:sideViewController];
    [sideViewController didMoveToParentViewController:self];
    
    sideViewController.view.frame = CGRectMake(0, 0, self.mainPanelViewController.view.frame.size.width, self.mainPanelViewController.view.frame.size.height);
    
    // set up view shadow
    [self showCenterViewWithShadow:YES];
    
    return sideViewController.view;
}

-(void)resetPanels
{
    
    //NSLog(@"resetPanels...");
    [self.leftPanelViewController.view removeFromSuperview];
    [self.rightPanelViewController.view removeFromSuperview];
    
    self.showPanel = NO;
    
    // reset view shadow
    [self showCenterViewWithShadow:NO];
}


-(void)attachSnapBehavior
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.mainPanelViewController.view snapToPoint:self.anchorPoint];
    snap.damping = 0.5;
    [self.dynamicAnimator addBehavior:snap];
    
    [self.dynamicAnimator performSelector:@selector(removeAllBehaviors) withObject:nil afterDelay:1.0f];
}

#pragma mark - Delegate Actions

- (void)revealView:(UIView *)view
{
    [self.view sendSubviewToBack:view];
    
    float x;
    if([view isEqual:self.leftPanelViewController.view]){
        
        x = self.view.frame.size.width/2+PANEL_WIDTH;
        self.anchorPoint = CGPointMake(x, self.view.frame.size.height/2);
        
    } else {
        x = self.view.frame.size.width/2-PANEL_WIDTH;
        self.anchorPoint = CGPointMake(x, self.view.frame.size.height/2);
    }
    [self attachSnapBehavior];
    
    self.showPanel = YES;
}

- (void)movePanelToOriginalPosition
{
    //NSLog(@"PCVC - movePanelToOriginalPosition");
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
        //NSLog(@"UIGestureRecognizerStateBegan...");
        
        UIView __weak *childView = nil;
        
        if(velocity.x > 0){
            if(!self.showPanel){
                childView = [self prepareViewForSidePanelVC:self.leftPanelViewController];
            }
        } else {
            if(!self.showPanel){
                childView = [self prepareViewForSidePanelVC:self.rightPanelViewController];
            }
        }
        // make sure the view you're working with is front and center
        [self.view sendSubviewToBack:childView];
        [panGesture.view bringSubviewToFront:[panGesture view]];
    }
    
    if([panGesture state] == UIGestureRecognizerStateChanged){
        translatedPoint = [panGesture translationInView:self.view];
        float newX = panGesture.view.center.x + translatedPoint.x;
        panGesture.view.center = CGPointMake(newX, panGesture.view.center.y);
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    
    if([panGesture state] == UIGestureRecognizerStateEnded){
        //NSLog(@"UIGestureRecognizerStateEnded...");
        
        float originX = self.mainPanelViewController.view.frame.origin.x;
        
        if(!self.showPanel){
            if(originX <= -(PANEL_WIDTH/2)){
                NSLog(@"slide left");
                [self revealView:self.rightPanelViewController.view];
            } else if (originX >=PANEL_WIDTH/2){
                NSLog(@"slide right");
                [self revealView:self.leftPanelViewController.view];
            } else {
                [self movePanelToOriginalPosition];
            }
        } else {
            [self movePanelToOriginalPosition];
        }
    }
}

#pragma mark - Notifications

-(void)showHideLeftPanel:(NSNotification *)notification
{
    if([self.view.subviews containsObject:self.leftPanelViewController.view]){
        [self movePanelToOriginalPosition];
    } else {
        UIView *leftPanelView = [self prepareViewForSidePanelVC:self.leftPanelViewController];
        [self.view sendSubviewToBack:leftPanelView];
        [self revealView:self.leftPanelViewController.view];
    }
}

#pragma mark - UICollisionBehaviorDelegate 

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{
    [self.dynamicAnimator performSelector:@selector(removeAllBehaviors) withObject:nil afterDelay:0.5];
}

@end
