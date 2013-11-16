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

-(void)updateRelationshipsForObjectSet:(NSSet *)managedObjectSet
{
    //NSLog(@"%@ updateRelationshipsForObjectSet",[[managedObjectSet anyObject] class]);
    //NSLog(@"set count = %i",[managedObjectSet count]);
    for(Varietal *varietal in managedObjectSet){
        varietal.wines = [self updateRelationshipSet:varietal.wines ofEntitiesNamed:WINE usingIdentifiersString:varietal.wineIdentifiers];
    }
}


-(void)updateManagedObjectsWithEntityName:(NSString *)entityName withDictionariesInArray:(NSArray *)managedObjectDictionariesArray
{
    if([entityName isEqualToString:WINE]){
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:self.context];
        [wdh updateManagedObjectsWithDictionariesInArray:managedObjectDictionariesArray];
    }
}



@end
