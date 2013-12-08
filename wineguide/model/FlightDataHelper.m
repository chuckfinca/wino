//
//  FlightDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "FlightDataHelper.h"
#import "Flight+CreateAndModify.h"
#import "Wine.h"
#import "Restaurant.h"


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
            
        } else if ([self.relatedObject class] == [Wine class]){
            flight.wines = [self addRelationToSet:flight.wines];
        }
    }
}

@end
