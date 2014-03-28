//
//  TimelineCellReviewTVController.h
//  Corkie
//
//  Created by Charles Feinn on 3/27/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TastingRecord.h"

@interface TimelineCellReviewTVController : UITableViewController

-(void)setupWithTastingRecord:(TastingRecord *)tastingRecord;

@end
