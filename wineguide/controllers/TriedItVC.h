//
//  TriedItVC.h
//  Corkie
//
//  Created by Charles Feinn on 12/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"
#import "Restaurant.h"

@interface TriedItVC : UIViewController

-(void)setupWithWine:(Wine *)wine andRestaurant:(Restaurant *)restaurant;

@end
