//
//  RestaurantTVC.h
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Restaurant.h"

@interface RestaurantCDTVC : CoreDataTableViewController

-(void)setupWithRestaurant:(Restaurant *)restaurant;

@end
