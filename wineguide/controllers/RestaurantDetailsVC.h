//
//  RestaurantDetailsViewController.h
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@protocol RestaurantDetailsVC_WineSelectionDelegate

- (void)loadWineList:(int)listNumber;

@end

@interface RestaurantDetailsVC : UIViewController

@property (nonatomic, weak) id <RestaurantDetailsVC_WineSelectionDelegate> delegate;

-(void)setupWithRestaurant:(Restaurant *)restaurant;

@end
