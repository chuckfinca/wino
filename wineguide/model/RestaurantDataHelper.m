//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDataHelper.h"
#import "Restaurant+Create.h"

@implementation RestaurantDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    NSLog(@"dictionary = %@",dictionary);
    [Restaurant restaurantWithInfo:dictionary inContext:context];
}



@end
