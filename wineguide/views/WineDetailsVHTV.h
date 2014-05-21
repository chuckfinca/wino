//
//  WineDetailsVHTV.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine2.h"
#import "Restaurant2.h"
#import "VariableHeightTV.h"

@interface WineDetailsVHTV : VariableHeightTV

-(void)setupTextViewWithWine:(Wine2 *)wine fromRestaurant:(Restaurant2 *)restaurant;

@end
