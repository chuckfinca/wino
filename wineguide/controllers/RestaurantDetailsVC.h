//
//  RestaurantDetailsViewController.h
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantDetailsVC : UIViewController

-(void)setupWithRestaurant:(Restaurant *)restaurant;

@end
