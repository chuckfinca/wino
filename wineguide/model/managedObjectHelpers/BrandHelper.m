//
//  BrandHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "BrandHelper.h"
#import "Brand2+Modify.h"
#import "WineHelper.h"
#import "Wine2.h"

#define BRAND_WINES @"wine"

@implementation BrandHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Brand2 *brand = (Brand2 *)[self findOrCreateManagedObjectEntityType:BRAND_ENTITY usingDictionary:dictionary];
    [brand modifyAttributesWithDictionary:dictionary];
    
    return brand;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Brand2 *brand = (Brand2 *)managedObject;
    
    if ([self.relatedObject class] == [Wine2 class]){
        brand.wines = [self addRelationToSet:brand.wines];
    }
}


-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Brand2 *brand = (Brand2 *)managedObject;
    
    // Wine
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[BRAND_WINES] withRelatedObject:brand];
}









@end
