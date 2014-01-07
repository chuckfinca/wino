//
//  TastingRecord+CreateAndModify.m
//  Corkie
//
//  Created by Charles Feinn on 1/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecord+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSManagedObject+Helper.h"
#import "NSDictionary+Helper.h"
#import "RestaurantDataHelper.h"
#import "WineDataHelper.h"
#import "User.h"
#import "Wine.h"


#define TASTING_RECORD_ENTITY @"TastingRecord"
#define USER_ENTITY @"User"
#define WINE_ENTITY @"Wine"

#define ADDED_DATE @"addedDate"
#define TASTING_DATE @"tastingDate"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define DELETED_ENTITY @"deletedEntity"

#define FLIGHTS @"flights"
#define GROUPS @"groups"
#define WINE_UNITS @"wineUnits"

@implementation TastingRecord (CreateAndModify)

+(TastingRecord *)tastingRecordFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    TastingRecord *tastingRecord = nil;
    
    tastingRecord = (TastingRecord *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:TASTING_RECORD_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [tastingRecord lastUpdatedDateFromDictionary:dictionary];
    
    if(!tastingRecord.lastServerUpdate || [tastingRecord.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        // EXEPTION: user updates a restaurant group on their iPhone and a restaurant flight on their iPad
        // in that case we need to make sure that the server processes the first change first, then the second, and that the device only hears from the server after it's own changes have been registered.
        
        
        // ATTRIBUTES
        tastingRecord.addedDate = [dictionary sanitizedStringForKey:ADDED_DATE];
        tastingRecord.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
        //restaurant.isPlaceholderForFutureObject = @NO;
        tastingRecord.lastServerUpdate = dictionaryLastUpdatedDate;
        tastingRecord.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
        // restaurant.menuNeedsUpdating - used to notify server that we need to update a specific restaurant's menu.
        
        [tastingRecord updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([tastingRecord.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [tastingRecord updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    //[restaurant logDetails];
    
    return tastingRecord;
}

-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON, if not then update the appropriate relationshipIdentifiers attribute
    /*
    // Restaurants
    RestaurantDataHelper *rdh = [[RestaurantDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[RESTAURANT_IDENTIFIER]];
    [rdh updateNestedManagedObjectsLocatedAtKey:RESTAURANT_IDENTIFIER inDictionary:dictionary];
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_IDENTIFIERS]];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
     */
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"added date = %@",self.addedDate);
    NSLog(@"tasting Date = %@",self.tastingDate);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    
        
    NSLog(@"\n\n\n");
}





@end
