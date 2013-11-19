//
//  VarietalDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "VarietalDataHelper.h"
#import "Varietal+CreateAndModify.h"
#import "WineDataHelper.h"

#define WINE @"Wine"

@implementation VarietalDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Varietal varietalFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Varietal class]]){
        Varietal *varietal = (Varietal *)managedObject;
        
        if ([self.relatedObject class] == [Wine class]){
            varietal.wines = [self addRelationToSet:varietal.wines];
        }
    }
}


@end
