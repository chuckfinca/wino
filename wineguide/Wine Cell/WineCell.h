//
//  WineCell.h
//  Corkie
//
//  Created by Charles Feinn on 5/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"

@interface WineCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *talkingHeadsButtonArray;

-(void)setupCellForWine:(Wine *)wine;

@end
