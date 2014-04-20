//
//  Review2.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TastingRecord2, User2, Wine2;

@interface Review2 : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * claimed;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * review_text;
@property (nonatomic, retain) TastingRecord2 *tastingRecord;
@property (nonatomic, retain) Wine2 *wine;
@property (nonatomic, retain) User2 *user;

@end
