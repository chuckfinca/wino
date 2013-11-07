//
//  Grouping+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/4/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Grouping+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "WineDataHelper.h"

#define GROUPING_ENTITY @"Grouping"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define VERSION @"version"

#define WINES @"wines"

@implementation Grouping (CreateAndModify)

+(Grouping *)groupFromRestaurant:(Restaurant *)restaurant foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Grouping *grouping = nil;
    
    grouping = (Grouping *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:GROUPING_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(grouping){
        
        // ATTRIBUTES
        
        grouping.about = [dictionary objectForKeyNotNull:ABOUT];
        grouping.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // grouping.lastAccessed
        grouping.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        grouping.name = [dictionary objectForKeyNotNull:NAME];
        grouping.version = [dictionary objectForKeyNotNull:VERSION];
        
        
        // RELATIONSHIPS
        
        // Restaurant
        grouping.restaurant = restaurant;
        
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] init];
        wdh.restaurant = restaurant;
        wdh.parentManagedObject = grouping;
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    }
    
    return grouping;
}

-(NSString *)description
{
    return self.identifier;
}

@end
