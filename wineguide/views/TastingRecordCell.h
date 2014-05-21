//
//  TastingRecordCell.h
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TastingRecord2.h"

@interface TastingRecordCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *userImageButtonArray;

-(void)setupWithTastingRecord:(TastingRecord2 *)tastingRecord andDisplayWineName:(BOOL)displayWineName;

@end
