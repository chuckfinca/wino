//
//  WineUnitDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineUnitDataHelper.h"
#import "WineUnit+CreateAndModify.h"
#import "Restaurant.h"

@implementation WineUnitDataHelper

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    [WineUnit wineUnitFromRestaurant:(Restaurant *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationships
{
    
}

@end
