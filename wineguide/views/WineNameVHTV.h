//
//  WineNameVHTV.h
//  Gimme
//
//  Created by Charles Feinn on 12/13/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Wine.h"
#import "Restaurant.h"
#import "VariableHeightTV.h"

@interface WineNameVHTV : VariableHeightTV

-(void)setupTextViewWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant;

@end
