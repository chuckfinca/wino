//
//  NSManagedObject+Helper.h
//  wineguide
//
//  Created by Charles Feinn on 11/9/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helper)

@property (nonatomic, retain) NSString *identifier; // abstract

-(NSString *)addIdentifiers:(NSString *)newIdentifiers toCurrentIdentifiers:(NSString *)currentIdentifiers;
-(NSDate *)lastUpdatedDateFromDictionary:(NSDictionary *)dictionary;

@end
