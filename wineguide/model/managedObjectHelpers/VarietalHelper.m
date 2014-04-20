//
//  VarietalHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "VarietalHelper.h"
#import "Varietal2+Modify.h"
#import "WineHelper.h"
#import "Wine2.h"

#define VARIETAL_WINES @"wines"

@implementation VarietalHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Varietal2 *varietal = (Varietal2 *)[self findOrCreateManagedObjectEntityType:BRAND_ENTITY usingDictionary:dictionary];
    [varietal modifyAttributesWithDictionary:dictionary];
    
    return varietal;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Varietal2 *varietal = (Varietal2 *)managedObject;
    
    if ([self.relatedObject class] == [Wine2 class]){
        varietal.wines = [self addRelationToSet:varietal.wines];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Varietal2 *varietal = (Varietal2 *)managedObject;
    
    // Wine
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[VARIETAL_WINES] withRelatedObject:varietal];
}











@end









