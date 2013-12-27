//
//  ReviewersAndRatingsVC.h
//  Corkie
//
//  Created by Charles Feinn on 12/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"

typedef enum {
    RatingsCollectionView,
    ReviewersCollectionView
} CollectionViewType;

@interface ReviewersAndRatingsVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *reviewersCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *ratingsCollectionView;
@property (nonatomic) BOOL favorite;

-(void)setupForWine:(Wine *)wine;

@end
