//
//  TastingRecordCell.h
//  Corkie
//
//  Created by Charles Feinn on 3/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"
#import "Restaurant.h"

@interface TastingRecordCell : UITableViewCell

-(void)setupWithDateString:(NSString *)dateString wine:(Wine *)wine restaurant:(Restaurant *)restaurant andReviewsArray:(NSArray *)reviewsArray;
-(float)height;

@end
