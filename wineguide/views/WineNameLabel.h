//
//  WineNameLabel.h
//  Corkie
//
//  Created by Charles Feinn on 5/15/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"
#import "Restaurant.h"

@interface WineNameLabel : UILabel

-(void)setupForWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant;

@end
