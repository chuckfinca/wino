//
//  SlidePanelsContainerViewController.h
//  SlideMenu
//
//  Created by Charles Feinn on 10/24/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanelsContainerViewController : UIViewController

@property (nonatomic, strong) UIViewController *mainPanelViewController; // abstract
@property (nonatomic, strong) UIViewController *leftPanelViewController; // abstract
@property (nonatomic, strong) UIViewController *rightPanelViewController; // abstract

@end