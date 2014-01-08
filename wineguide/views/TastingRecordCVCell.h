//
//  TastingRecordView.h
//  Corkie
//
//  Created by Charles Feinn on 1/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TastingRecord.h"

@interface TastingRecordCVCell : UICollectionViewCell

-(void)setupCellWithTastingRecord:(TastingRecord *)tastingRecord;
-(float)cellHeight;

@end
