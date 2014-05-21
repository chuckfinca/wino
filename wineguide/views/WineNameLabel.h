//
//  WineNameLabel.h
//  Corkie
//
//  Created by Charles Feinn on 5/15/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine2.h"
#import "Restaurant2.h"

@interface WineNameLabel : UILabel

-(void)setupForWine:(Wine2 *)wine fromRestaurant:(Restaurant2 *)restaurant;

@end
