//
//  TastingRecordObjectHandler.h
//  Corkie
//
//  Created by Charles Feinn on 3/26/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ManagedObjectHandler.h"
#import "TastingRecord.h"
#import "Review.h"

@interface TastingRecordObjectHandler : ManagedObjectHandler

+(TastingRecord *)createTastingRecordWithIdentifier:(NSString *)identifier tastingDate:(NSDate *)tastingDate review:(Review *)review restaurant:(Restaurant *)restaurant andFriends:(NSArray *)friendsArray;

@end
