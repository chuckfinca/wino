//
//  RestaurantTVC.h
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Searchable_ICDTVC.h"
#import "Restaurant2.h"

@interface Restaurant_SICDTVC : Searchable_ICDTVC

-(void)setupWithRestaurant:(Restaurant2 *)restaurant;

@end
