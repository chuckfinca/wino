//
//  WineCDTVC.h
//  wineguide
//
//  Created by Charles Feinn on 11/2/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TastingRecordSCDTVC.h"
#import "Wine.h"
#import "Restaurant.h"

@interface WineTRSCDTVC : TastingRecordSCDTVC

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant;

@end
