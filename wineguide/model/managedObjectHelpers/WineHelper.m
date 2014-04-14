//
//  WineHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineHelper.h"
#import "Wine2+Modify.h"



#define RESTAURANT_WINE_UNITS @"wine_units"
#define RESTAURANT_GROUPS @"groups"
#define RESTAURANT_FLIGHTS @"flights"


#define WINE_ID @"wine_id"
#define RESTAURANT_ID @"restaurant_id"

@implementation WineHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Wine2 *wine = (Wine2 *)[self findOrCreateManagedObjectEntityType:WINE_ENTITY andIdentifier:dictionary[ID_KEY]];
    [wine modifyAttributesWithDictionary:dictionary];
    
    // wine
    NSNumber *wineIdentifier = dictionary[WINE_ID];
    
    
    return wine;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Wine2 class]]){
        Wine2 *wine = (Wine2 *)managedObject;
        
        /*
        if([self.relatedObject class] == [Brand2 class]){
            wine.brand = (Brand2 *)self.relatedObject;
            
        } else if ([self.relatedObject class] == [TastingNote2 class]){
            wine.tastingNotes = [self addRelationToSet:wine.tastingNotes];
            
        } else if([self.relatedObject class] == [Flight2 class]){
            wine.flights = [self addRelationToSet:wine.flights];
            
        } else if ([self.relatedObject class] == [Group2 class]){
            wine.groups = [self addRelationToSet:wine.groups];
            
        } else if ([self.relatedObject class] == [WineUnit2 class]){
            wine.wineUnits = [self addRelationToSet:wine.wineUnits];
            
        } else if ([self.relatedObject class] == [Varietal2 class]){
            wine.varietals = [self addRelationToSet:wine.varietals];
            */
            
            /*
             if([wine.varietals count] == 1){
             Varietal *v = (Varietal2 *)[wine.varietals anyObject];
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


@end
