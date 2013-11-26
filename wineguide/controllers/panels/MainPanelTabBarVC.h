//
//  CenterViewController.h
//  SlideMenu
//
//  Created by Charles Feinn on 10/24/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MainPanelViewControllerDelegate <NSObject>

@optional
-(void)movePanelLeft;
-(void)movePanelRight;

@required
-(void)movePanelToOriginalPosition;

@end

@interface MainPanelTabBarVC : UITabBarController

@property (nonatomic) id <MainPanelViewControllerDelegate> mainPanelViewDelegate;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end
