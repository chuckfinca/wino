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

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    [Flight flightFromRestaurant:(Restaurant *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)setRelationIdentifiersAttribute:(NSString *)string
{
    Restaurant *restaurant = (Restaurant *)self.parentManagedObject;
    restaurant.flightIdentifiers = string;
    NSLog(@"restaurant.flightIdentifiers = %@",restaurant.flightIdentifiers);
}

@end
