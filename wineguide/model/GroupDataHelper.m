//
//  GroupingDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "GroupDataHelper.h"
#import "Group+CreateAndModify.h"
#import "Restaurant.h"
#import "Wine.h"

@implementation GroupDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Group groupFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Group class]]){
        Group *group = (Group *)managedObject;
        
        if([self.relatedObject class] == [Restaurant class]){
            group.restaurant = (Restaurant *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [Wine class]){
            group.wines = [self addRelationToSet:group.wines];
        }
    }
}

@end
