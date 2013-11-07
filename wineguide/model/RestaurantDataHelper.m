//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+CreateAndModify.h"

@implementation RestaurantDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    [Restaurant restaurantFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

@end
