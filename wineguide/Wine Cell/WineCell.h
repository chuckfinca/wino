//
//  WineCell.h
//  Corkie
//
//  Created by Charles Feinn on 5/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine2.h"

@interface WineCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *talkingHeadsArray;
@property (nonatomic) NSInteger numberOfTalkingHeads;

-(void)setupCellForWine:(Wine2 *)wine;

@end
