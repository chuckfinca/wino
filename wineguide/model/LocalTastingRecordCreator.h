//
//  CreateLocalTastingRecord.h
//  Corkie
//
//  Created by Charles Feinn on 6/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetMe.h"
#import "Restaurant2.h"
#import "Wine2.h"
#import "TastingRecord2.h"

@interface LocalTastingRecordCreator : NSObject

-(TastingRecord2 *)createTastingRecordAndReviewWithText:(NSString *)reviewText
                                     rating:(float)rating
                                       wine:(Wine2 *)wine
                                 restaurant:(Restaurant2 *)restaurant
                                tastingDate:(NSDate *)tastingDate
                                 andFriends:(NSArray *)selectedFriends;

@end
