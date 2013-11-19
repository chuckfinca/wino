//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+CreateAndModify.h"
#import "GroupingDataHelper.h"
#import "FlightDataHelper.h"
#import "Group.h"
#import "Flight.h"

#define GROUP @"Group"
#define FLIGHT @"Flight"


@implementation RestaurantDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Restaurant restaurantFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Restaurant class]]){
        Restaurant *restaurant = (Restaurant *)managedObject;
        
        if([self.relatedObject class] == [Flight class]){
            restaurant.flights = [self addRelationToSet:restaurant.flights];
            
        } else if ([self.relatedObject class] == [Group class]){
            restaurant.groups = [self addRelationToSet:restaurant.groups];
        }
    }
}


@end
