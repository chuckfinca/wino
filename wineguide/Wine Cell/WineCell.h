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

-(void)setupCellForWine:(Wine *)wine;
-(void)setupTalkingHeadsForWine:(Wine *)wine cellAtIndexPath:(NSIndexPath *)indexPath ofTableView:(__weak UITableView *)tableView;

@end
