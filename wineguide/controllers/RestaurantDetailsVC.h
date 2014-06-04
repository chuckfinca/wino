//
//  RestaurantDetailsViewController.h
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant2.h"
#import "Group2.h"

@protocol WineListFilterDelegate <NSObject>

-(void)filterByGroup:(Group2 *)group;
-(void)removeFilterForGroup:(Group2 *)group;

@end

@interface RestaurantDetailsVC : UIViewController

@property (nonatomic, weak) id <WineListFilterDelegate> delegate;

-(void)setupWithRestaurant:(Restaurant2 *)restaurant;

@end
