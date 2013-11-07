//
//  WineDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDataHelper.h"
#import "Wine+CreateAndModify.h"
#import "Restaurant.h"

@implementation WineDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    [Wine wineFromRestaurant:self.restaurant foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


@end
