//
//  InitialTabBarController.h
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
