//
//  CheckInVC.h
//  Corkie
//
//  Created by Charles Feinn on 1/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"
#import "Restaurant.h"

@protocol CheckInVcDelegate

-(void)dismissAfterTastingRecordCreation;

@end

@interface CheckInVC : UIViewController

@property (nonatomic, weak) id <CheckInVcDelegate> delegate;

-(void)setupWithWine:(Wine *)wine andRestaurant:(Restaurant *)restaurant;

@end