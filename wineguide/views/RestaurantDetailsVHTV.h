//
//  RestaurantDetailsTV.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "VariableHeightTV.h"

@interface RestaurantDetailsVHTV : VariableHeightTV

-(void)setupTextViewWithRestaurant:(Restaurant *)restaurant;

@end
