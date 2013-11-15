//
//  BrandDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "BrandDataHelper.h"
#import "Brand+CreateAndModify.h"

#define WINE @"Wine"

@implementation BrandDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Brand brandFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    NSLog(@"set count = %i",[managedObjectSet count]);
    for(Brand *brand in managedObjectSet){
        brand.wines = [self updateRelationshipSet:brand.wines ofEntitiesNamed:WINE usingIdentifiersString:brand.wineIdentifiers];
    }
}

@end
