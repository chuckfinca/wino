//
//  TutorialVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TutorialVC.h"
#import "TutorialDetailsVC.h"
#import "ColorSchemer.h"

@interface TutorialVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageController;

@end

@implementation TutorialVC

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
    
    
    [self setupPageControl];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    self.pageController.dataSource = self;
    [self.pageController.view setFrame:self.view.bounds];
    
    [self setupPageForIndex:0 animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToNextPage) name:@"Continue To Next Page" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)setupPageForIndex:(int)index animated:(BOOL)animated
{
    TutorialDetailsVC *initialViewController = [self viewControllerAtIndex:index];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:animated
                                 completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

-(void)setupPageControl
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [ColorSchemer sharedInstance].textSecondary;
    pageControl.currentPageIndicatorTintColor = [ColorSchemer sharedInstance].baseColor;
    pageControl.backgroundColor = [ColorSchemer sharedInstance].customWhite;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TutorialDetailsVC *)viewControllerAtIndex:(NSUInteger)index
{
    TutorialDetailsVC *childViewController = [[TutorialDetailsVC alloc] initWithNibName:@"Tutorial" bundle:nil];
    childViewController.index = index;
    
    return childViewController;
}

#pragma mark - UIPageViewControllerDataSource

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [(TutorialDetailsVC *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
}

#define NUM_TUTORIAL_SCREENS 3

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [(TutorialDetailsVC *)viewController index];
    index++;
    
    if (index == NUM_TUTORIAL_SCREENS) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return NUM_TUTORIAL_SCREENS;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


-(void)moveToNextPage
{
    [self setupPageForIndex:1 animated:YES];
}

@end
