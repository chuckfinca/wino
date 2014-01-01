//
//  WineCardCell.h
//  Gimme
//
//  Created by Charles Feinn on 12/11/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"
#import "CollectionViewWithIndex.h"
#import "UserRatingCVController.h"

@interface WineCardCell : UICollectionViewCell

@property (nonatomic, strong) UserRatingCVController *userRatingsController;

-(void)setupCardWithWine:(Wine *)wine;

@end
