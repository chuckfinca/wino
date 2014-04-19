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

#define BRAND_WINES @"brand_wine"

@implementation BrandHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Brand2 *brand = (Brand2 *)[self findOrCreateManagedObjectEntityType:GROUP_ENTITY andIdentifier:dictionary[ID_KEY]];
    [brand modifyAttributesWithDictionary:dictionary];
    
    return brand;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Brand2 class]]){
        Brand2 *brand = (Brand2 *)managedObject;
        
        if ([self.relatedObject class] == [Wine2 class]){
            brand.wines = [self addRelationToSet:brand.wines];
        }
    }
}


-(void)addAdditionalRelativesToManagedObject:(NSManagedObject *)managedObject fromDictionary:(NSDictionary *)dictionary
{
    Brand2 *brand = (Brand2 *)managedObject;
    
    // Wine
    NSArray *winesArray = dictionary[BRAND_WINES];
    WineHelper *wu = [[WineHelper alloc] init];
    brand.wines = [self toManyRelationshipSetCreatedFromDictionariesArray:winesArray usingHelper:wu];
}









@end
