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
#import "TastingNoteHelper.h"
#import "TastingNote2.h"
#import "VarietalHelper.h"
#import "Varietal2.h"
#import "UserHelper.h"
#import "User2.h"
#import "RegionHelper.h"
#import "Region.h"
#import "TastingRecordHelper.h"
#import "TastingRecord2.h"
#import "WineList.h"
#import "WineListHelper.h"

#define WINE_BRAND @"brand"
#define WINE_FLIGHTS @"flights"
#define WINE_GROUPS @"groups"
#define WINE_RATING_HISTORY @"rating_history"
#define WINE_WINE_UNITS @"wine_units"
#define WINE_TASTING_NOTES @"tasting_notes"
#define WINE_VARIETALS @"varietals"
#define WINE_REGIONS @"regions"
#define WINE_CELLARS @"cellars"
#define WINE_TASTING_RECORDS @"tasting_records"
#define WINE_WINE_LISTS @"wine_lists"


@implementation WineHelper

-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    Wine2 *wine = (Wine2 *)[self findOrCreateManagedObjectEntityType:WINE_ENTITY usingDictionary:dictionary];
    [wine modifyAttributesWithDictionary:dictionary];
    return wine;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
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
        
    } else if ([self.relatedObject class] == [TastingNote2 class]){
        wine.tastingNotes = [self addRelationToSet:wine.tastingNotes];
        
    } else if ([self.relatedObject class] == [Varietal2 class]){
        wine.varietals = [self addRelationToSet:wine.varietals];
        
    } else if ([self.relatedObject class] == [Region class]){
        wine.regions = [self addRelationToSet:wine.regions];
        
    } else if ([self.relatedObject class] == [User2 class]){
        wine.cellars = [self addRelationToSet:wine.cellars];
        
    } else if ([self.relatedObject class] == [TastingRecord2 class]){
        wine.tastingRecords = [self addRelationToSet:wine.tastingRecords];
        
    } else if ([self.relatedObject class] == [WineList class]){
        wine.wineLists = [self addRelationToSet:wine.wineLists];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    Wine2 *wine = (Wine2 *)managedObject;
    
    // Brand
    BrandHelper *bh = [[BrandHelper alloc] init];
    [bh processJSON:dictionary[WINE_BRAND] withRelatedObject:wine];
    
    // Flights
    FlightHelper *fh = [[FlightHelper alloc] init];
    [fh processJSON:dictionary[WINE_FLIGHTS] withRelatedObject:wine];
    
    // Groups
    GroupHelper *gh = [[GroupHelper alloc] init];
    [gh processJSON:dictionary[WINE_GROUPS] withRelatedObject:wine];
    
    // Wine Units
    WineUnitHelper *wuh = [[WineUnitHelper alloc] init];
    [wuh processJSON:dictionary[WINE_WINE_UNITS] withRelatedObject:wine];
    
    // Rating History
    RatingHistoryHelper *rhh = [[RatingHistoryHelper alloc] init];
    [rhh processJSON:dictionary[WINE_RATING_HISTORY] withRelatedObject:wine];
    
    // Tasting Notes
    TastingNoteHelper *tnh = [[TastingNoteHelper alloc] init];
    [tnh processJSON:dictionary[WINE_TASTING_NOTES] withRelatedObject:wine];
    
    // Varietal
    VarietalHelper *vh = [[VarietalHelper alloc] init];
    [vh processJSON:dictionary[WINE_VARIETALS] withRelatedObject:wine];
    
    // Regions
    RegionHelper *rh = [[RegionHelper alloc] init];
    [rh processJSON:dictionary[WINE_REGIONS] withRelatedObject:wine];
    
    // Cellars
    UserHelper *uh = [[UserHelper alloc] init];
    [uh processJSON:dictionary[WINE_CELLARS] withRelatedObject:wine];
    
    // Reviews
    TastingRecordHelper *trh = [[TastingRecordHelper alloc] init];
    [trh processJSON:dictionary[WINE_TASTING_RECORDS] withRelatedObject:wine];
    
    // Wine Lists
    WineListHelper *wlh = [[WineListHelper alloc] init];
    [wlh processJSON:dictionary[WINE_WINE_LISTS] withRelatedObject:wine];
    
}










@end
