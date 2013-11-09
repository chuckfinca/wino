//
//  FlightDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "FlightDataHelper.h"
#import "Flight+CreateAndModify.h"
#import "Restaurant.h"

@implementation FlightDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Flight flightFromRestaurant:(Restaurant *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Flight *flight in managedObjectSet){
        flight.wines = [self updateManagedObject:flight relationshipSet:flight.wines withIdentifiersString:flight.wineIdentifiers];
    }
}

@end
