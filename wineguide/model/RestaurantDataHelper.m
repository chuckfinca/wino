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

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    [Restaurant restaurantWithInfo:dictionary inContext:context];
}



@end
