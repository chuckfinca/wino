//
//  WineCell.h
//  Gimme
//
//  Created by Charles Feinn on 12/3/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"

@interface WineCell : UITableViewCell

@property (nonatomic) BOOL abridged;

-(void)setupCellForWine:(Wine *)wine;
-(void)setupCellForWine:(Wine *)wine numberOfTalkingHeads:(NSInteger)numberOfTalkingHeads; // for testing ONLY

@end
