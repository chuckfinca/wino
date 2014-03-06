//
//  WineDetailsVHTV.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine.h"
#import "Restaurant.h"
#import "VariableHeightTV.h"

@interface WineDetailsVHTV : VariableHeightTV

-(void)setupTextViewWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant;

@end
