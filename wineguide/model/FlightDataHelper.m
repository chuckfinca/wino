//
//  FlightDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "FlightDataHelper.h"
#import "Flight+CreateAndModify.h"
#import "RestaurantDataHelper.h"
#import "WineUnitDataHelper.h"
#import "WineUnit.h"
#import "Restaurant.h"

#define WINE_UNIT @"WineUnit"
#define RESTAURANT @"Restaurant"

@implementation FlightDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Flight flightFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Flight class]]){
        Flight *flight = (Flight *)managedObject;
        
        if([self.relatedObject class] == [Restaurant class]){
            flight.restaurant = (Restaurant *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [WineUnit class]){
            flight.wineUnits = [self addRelationToSet:flight.wineUnits];
            
        }
    }
}

@end
