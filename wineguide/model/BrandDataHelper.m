//
//  BrandDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "BrandDataHelper.h"
#import "Brand+CreateAndModify.h"
#import "Wine.h"

@implementation BrandDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Brand brandForWine:(Wine *)self.parentManagedObject foundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Brand *brand in managedObjectSet){
        brand.wines = [self updateManagedObject:brand relationshipSet:brand.wines withIdentifiersString:brand.wineIdentifiers];
    }
}

@end
