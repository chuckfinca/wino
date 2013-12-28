//
//  WineDetailsVC.h
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"
#import "Restaurant.h"

@protocol WineDetailsVcDelegate

- (void)performTriedItSegue;

@end

@interface WineDetailsVC : UIViewController

@property (nonatomic, weak) id <WineDetailsVcDelegate> delegate;

-(void)setupWithWine:(Wine *)wine fromRestaurant:(Restaurant *)restaurant;

@end
