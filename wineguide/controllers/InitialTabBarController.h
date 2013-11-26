//
//  InitialTabBarController.h
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPanelTabBarVC.h"

@interface InitialTabBarController : MainPanelTabBarVC

@property (nonatomic, readonly) NSManagedObjectContext *context;

@end
