//
//  GroupingDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "GroupingDataHelper.h"
#import "Grouping+CreateAndModify.h"
#import "Restaurant.h"

@implementation GroupingDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Grouping groupFromRestaurant:(Restaurant *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Grouping *grouping in managedObjectSet){
        grouping.wines = [self updateManagedObject:grouping relationshipSet:grouping.wines withIdentifiersString:grouping.wineIdentifiers];
    }
}

@end
