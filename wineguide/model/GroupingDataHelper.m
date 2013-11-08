//
//  GroupingDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "GroupingDataHelper.h"
#import "Grouping+CreateAndModify.h"
#import "Restaurant.h"

@implementation GroupingDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    [Grouping groupFromRestaurant:(Restaurant *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

@end
