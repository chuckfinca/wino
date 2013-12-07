//
//  WineUnitDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineUnitDataHelper.h"
#import "WineUnit+CreateAndModify.h"
#import "Wine.h"
#import "WineDataHelper.h"

#define GROUP @"Group"
#define FLIGHT @"Flight"
#define WINE @"Wine"

@implementation WineUnitDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [WineUnit wineUnitFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[WineUnit class]]){
        WineUnit *wineUnit = (WineUnit *)managedObject;
        
        if([self.relatedObject class] == [Restaurant class]){
            wineUnit.restaurant = (Restaurant *)self.relatedObject;
            
        } else if([self.relatedObject class] == [Wine class]){
            wineUnit.wine = (Wine *)self.relatedObject;
        }
    }
}

    
    
    
    
    
    @end
