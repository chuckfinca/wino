//
//  BrandDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "BrandDataHelper.h"
#import "Brand+CreateAndModify.h"
#import "WineDataHelper.h"

#define WINE @"Wine"

@implementation BrandDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Brand brandFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Brand class]]){
        Brand *brand = (Brand *)managedObject;
        
        if ([self.relatedObject class] == [Wine class]){
            brand.wines = [self addRelationToSet:brand.wines];
        }
    }
}


@end
