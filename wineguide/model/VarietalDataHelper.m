//
//  VarietalDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "VarietalDataHelper.h"
#import "Varietal+CreateAndModify.h"

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
            
            Wine *wine = (Wine *)self.relatedObject;
            if([wine.varietals count] == 1){
                Varietal *v = (Varietal *)[wine.varietals anyObject];
                wine.varietalCategory = [NSString stringWithFormat:@"%@-%@",[wine.color substringToIndex:1],v.name];
            } else {
                if([wine.color isEqualToString:@"red"]){
                    wine.varietalCategory = @"r-red wine";
                } else {
                    wine.varietalCategory = @"w-white wine";
                }
            }
        }
    }
}


@end
