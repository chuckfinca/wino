//
//  Restaurant2.h
//  Corkie
//
//  Created by Charles Feinn on 5/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TastingRecord2, WineList;

@interface Restaurant2 : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * street_1;
@property (nonatomic, retain) NSString * street_2;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *tastingRecords;
@property (nonatomic, retain) WineList *wineList;
@end

@interface Restaurant2 (CoreDataGeneratedAccessors)

- (void)addTastingRecordsObject:(TastingRecord2 *)value;
- (void)removeTastingRecordsObject:(TastingRecord2 *)value;
- (void)addTastingRecords:(NSSet *)values;
- (void)removeTastingRecords:(NSSet *)values;

@end
