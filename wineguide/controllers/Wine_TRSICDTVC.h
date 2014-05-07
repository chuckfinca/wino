//
//  WineCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingRecord_SICDTVC.h"
#import "Wine.h"
#import "Restaurant.h"

@interface Wine_TRSICDTVC : TastingRecord_SICDTVC

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant;

@end
