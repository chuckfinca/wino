//
//  TalkingHeads.h
//  Corkie
//
//  Created by Charles Feinn on 5/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User2, Wine2;

@interface TalkingHeads : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *users;
@property (nonatomic, retain) Wine2 *wine;
@end

@interface TalkingHeads (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User2 *)value;
- (void)removeUsersObject:(User2 *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
