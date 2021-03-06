//
//  RegionHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RegionHelper.h"
#import "Region+Modify.h"
#import "WineHelper.h"
#import "Wine2.h"

#define REGION_WINES @"wines" //////////////

@implementation RegionHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Region *region = (Region *)[self findOrCreateManagedObjectEntityType:REGION_ENTITY usingDictionary:dictionary];
    [region modifyAttributesWithDictionary:dictionary];
    
    return region;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    Region *region = (Region *)managedObject;
    
    if ([self.relatedObject class] == [Wine2 class]){
        region.wines = [self addRelationToSet:region.wines];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Region *region = (Region *)managedObject;
    
    // Wine
    WineHelper *wu = [[WineHelper alloc] init];
    [wu processJSON:dictionary[REGION_WINES] withRelatedObject:region];
}









@end









