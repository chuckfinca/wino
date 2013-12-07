//
//  GroupingDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "GroupDataHelper.h"
#import "Group+CreateAndModify.h"
#import "RestaurantDataHelper.h"
#import "WineUnitDataHelper.h"
#import "Restaurant.h"
#import "WineUnit.h"

#define WINE_UNIT @"WineUnit"
#define GROUP @"Group"
#define RESTAURANT @"Restaurant"

@implementation GroupDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Group groupFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Group class]]){
        Group *group = (Group *)managedObject;
        
        if([self.relatedObject class] == [Restaurant class]){
            group.restaurant = (Restaurant *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [WineUnit class]){
            group.wines = [self addRelationToSet:group.wines];
            
        }
    }
}

@end
