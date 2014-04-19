//
//  RatingHistoryHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingHistoryHelper.h"
#import "RatingHistory2+Modify.h"
#import "WineHelper.h"
#import "Wine2.h"

@implementation RatingHistoryHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    RatingHistory2 *ratingHistory = (RatingHistory2 *)[self findOrCreateManagedObjectEntityType:RATING_HISTORY_ENTITY andIdentifier:dictionary[ID_KEY]];
    [ratingHistory modifyAttributesWithDictionary:dictionary];
    
    return ratingHistory;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[RatingHistory2 class]]){
        RatingHistory2 *ratingHistory = (RatingHistory2 *)managedObject;
        
        if ([self.relatedObject class] == [Wine2 class]){
            ratingHistory.wine = (Wine2 *)self.relatedObject;
        }
    }
}











@end
