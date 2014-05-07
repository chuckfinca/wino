//
//  RestaurantTVC.h
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Searchable_ICDTVC.h"
#import "Restaurant.h"

@interface Restaurant_ISCDTVC : Searchable_ICDTVC

-(void)setupWithRestaurant:(Restaurant *)restaurant;

@end
