//
//  SidePanelViewController.h
//  SlideMenu
//
//  Created by Charles Feinn on 10/25/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SidePanelViewControllerDelegate <NSObject>

@required
-(void)refreshViewControllerWithOptions:(NSDictionary *)options;  // placeholder / catch all

@end



@interface SidePanelViewController : UIViewController

@property (nonatomic, assign) id <SidePanelViewControllerDelegate> delegate;

@end
