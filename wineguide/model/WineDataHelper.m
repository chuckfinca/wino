//
//  WineDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDataHelper.h"
#import "Wine+CreateAndModify.h"
#import "Brand.h"
#import "Flight.h"
#import "Group.h"
#import "TastingNote.h"
#import "WineUnit.h"
#import "Varietal.h"

#define WINE_UNIT @"WineUnit"
#define TASTING_NOTE @"TastingNote"
#define VARIETAL @"Varietal"
#define BRAND @"Brand"

@implementation WineDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [Wine wineFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Wine class]]){
        Wine *wine = (Wine *)managedObject;
        if([self.relatedObject class] == [Brand class]){
            wine.brand = (Brand *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [TastingNote class]){
            wine.tastingNotes = [self addRelationToSet:wine.tastingNotes];
            
        } else if([self.relatedObject class] == [Flight class]){
            wine.flights = [self addRelationToSet:wine.flights];
            
        } else if ([self.relatedObject class] == [Group class]){
            wine.groups = [self addRelationToSet:wine.groups];
            
        } else if ([self.relatedObject class] == [WineUnit class]){
            wine.wineUnits = [self addRelationToSet:wine.wineUnits];
            
        } else if ([self.relatedObject class] == [Varietal class]){
            wine.varietals = [self addRelationToSet:wine.varietals];
            
            /*
            if([wine.varietals count] == 1){
                Varietal *v = (Varietal *)[wine.varietals anyObject];
                wine.varietalCategory = [NSString stringWithFormat:@"%@-%@",[wine.color substringToIndex:2],v.name];
            } else {
                if([wine.color isEqualToString:@"red"]){
                    wine.varietalCategory = @"re-red wine";
                } else if([wine.color isEqualToString:@"rose"]){
                    wine.varietalCategory = @"ro-rose wine";
                } else if([wine.color isEqualToString:@"white"]){
                    wine.varietalCategory = @"wh-white wine";
                } else {
                    wine.varietalCategory = @"";
                }
            }
             */
        }
    }
}

@end
