//
//  WineCell.h
//  Gimme
//
//  Created by Charles Feinn on 12/3/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"
#import "CollectionViewWithIndex.h"

typedef enum {
    RatingsCollectionView,
    ReviewersCollectionView
} CollectionViewType;

@interface WineCell : UITableViewCell

@property (nonatomic) BOOL abridged;
@property (weak, nonatomic) IBOutlet CollectionViewWithIndex *ratingsCollectionView;
@property (weak, nonatomic) IBOutlet CollectionViewWithIndex *reviewersCollectionView;

-(void)setupCellForWine:(Wine *)wine;

@end
