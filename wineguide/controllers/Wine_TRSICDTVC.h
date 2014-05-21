//
//  WineCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingRecord_SICDTVC.h"
#import "Wine2.h"
#import "Restaurant2.h"

@interface Wine_TRSICDTVC : TastingRecord_SICDTVC

-(void)setupWithWine:(Wine2 *)wine fromRestaurant:(Restaurant2 *)restaurant;

@end
