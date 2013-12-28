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
#import "ReviewersAndRatingsVC.h"

@interface WineCell : UITableViewCell

@property (nonatomic) BOOL abridged;
@property (weak, nonatomic) IBOutlet UIView *ratingsAndReviewsView;
@property (nonatomic, strong) ReviewersAndRatingsVC *reviewersAndRatingsVC;

-(void)setupCellForWine:(Wine *)wine;

@end
