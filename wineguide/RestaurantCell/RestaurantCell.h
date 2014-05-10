//
//  RestaurantCell.h
//  Corkie
//
//  Created by Charles Feinn on 5/10/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantCell : UITableViewCell

-(void)setupCellForRestaurant:(Restaurant *)restaurant;

@end
