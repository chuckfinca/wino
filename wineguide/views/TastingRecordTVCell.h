//
//  TastingRecordTVCell.h
//  Corkie
//
//  Created by Charles Feinn on 2/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ServerHelper.h"
#import "TastingRecord.h"
#import "UserRatingCVController.h"

@interface TastingRecordTVCell : UITableViewCell

-(void)setupCellWithTastingRecord:(TastingRecord *)tastingRecord;

@end
