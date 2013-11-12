//
//  FlightDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "FlightDataHelper.h"
#import "Flight+CreateAndModify.h"

#define WINE_UNIT @"WineUnit"

@implementation FlightDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Flight flightFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Flight *flight in managedObjectSet){
        flight.wineUnits = [self updateRelationshipSet:flight.wineUnits ofEntitiesNamed:WINE_UNIT withIdentifiersString:flight.wineUnitIdentifiers];
    }
}

@end
