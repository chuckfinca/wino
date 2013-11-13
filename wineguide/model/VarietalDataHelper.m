//
//  VarietalDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "VarietalDataHelper.h"
#import "Varietal+CreateAndModify.h"

#define WINE @"Wine"

@implementation VarietalDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Varietal varietalFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    for(Varietal *varietal in managedObjectSet){
        varietal.wines = [self updateRelationshipSet:varietal.wines ofEntitiesNamed:WINE usingIdentifiersString:varietal.wineIdentifiers];
    }
}


@end
