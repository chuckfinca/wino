//
//  WineHelper.m
//  Corkie
//
//  Created by Charles Feinn on 4/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineHelper.h"
#import "Wine2+Modify.h"
#import "BrandHelper.h"
#import "Brand2.h"
#import "FlightHelper.h"
#import "Flight2.h"
#import "GroupHelper.h"
#import "Group2.h"
#import "WineUnitHelper.h"
#import "WineUnit2.h"
#import "RatingHistoryHelper.h"
#import "RatingHistory2.h"



#define WINE_BRAND @"brand"
#define WINE_FLIGHTS @"flights"
#define WINE_GROUPS @"groups"
#define WINE_RATING_HISTORY @"rating_history"
#define WINE_WINE_UNITS @"wine_units"


@implementation WineHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Wine2 *wine = (Wine2 *)[self findOrCreateManagedObjectEntityType:WINE_ENTITY andIdentifier:dictionary[ID_KEY]];
    [wine modifyAttributesWithDictionary:dictionary];
    return wine;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[Wine2 class]]){
        Wine2 *wine = (Wine2 *)managedObject;
        
        if([self.relatedObject class] == [Brand2 class]){
            wine.brand = (Brand2 *)self.relatedObject;
            
        } else if([self.relatedObject class] == [Flight2 class]){
            wine.flights = [self addRelationToSet:wine.flights];
            
        } else if ([self.relatedObject class] == [Group2 class]){
            wine.groups = [self addRelationToSet:wine.groups];
            
        } else if ([self.relatedObject class] == [WineUnit2 class]){
            wine.wineUnits = [self addRelationToSet:wine.wineUnits];
            
        } else if ([self.relatedObject class] == [RatingHistory2 class]){
            wine.ratingHistory = (RatingHistory2 *)self.relatedObject;
            
        }
        /* else if ([self.relatedObject class] == [TastingNote2 class]){
         wine.tastingNotes = [self addRelationToSet:wine.tastingNotes];
         
         } else if ([self.relatedObject class] == [Varietal2 class]){
         wine.varietals = [self addRelationToSet:wine.varietals];
         
         
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
-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Wine2 *wine = (Wine2 *)managedObject;
    
    // brand
    BrandHelper *bh = [[BrandHelper alloc] init];
    [bh processJSON:dictionary[WINE_BRAND] withRelatedObject:wine];
    
    // flights
    FlightHelper *fh = [[FlightHelper alloc] init];
    [fh processJSON:dictionary[WINE_FLIGHTS] withRelatedObject:wine];
    
    // groups
    GroupHelper *gh = [[GroupHelper alloc] init];
    [gh processJSON:dictionary[WINE_GROUPS] withRelatedObject:wine];
    
    // rating history
    RatingHistoryHelper *rhh = [[RatingHistoryHelper alloc] init];
    [rhh processJSON:dictionary[WINE_RATING_HISTORY] withRelatedObject:wine];
    
    // tasting records
    
    
    // wine units
    WineUnitHelper *wuh = [[WineUnitHelper alloc] init];
    [wuh processJSON:dictionary[WINE_WINE_UNITS] withRelatedObject:wine];
}


@end
