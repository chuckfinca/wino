//
//  serverHelper.h
//  Corkie
//
//  Created by Charles Feinn on 2/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define BRAND_ENTITY @"Brand2"
#define FLIGHT_ENTITY @"Flight2"
#define GROUP_ENTITY @"Group2"
#define RATING_HISTORY_ENTITY @"RatingHistory2"
#define REGION_ENTITY @"Region"
#define RESTAURANT_ENTITY @"Restaurant2"
#define TASTING_NOTE_ENTITY @"TastingNote2"
#define TASTING_RECORD_ENTITY @"TastingRecord2"
#define USER_ENTITY @"User2"
#define VARIETAL_ENTITY @"Varietal2"
#define WINE_ENTITY @"Wine2"
#define WINE_UNIT_ENTITY @"WineUnit2"

#define ID_KEY @"id"
#define WINE_ID @"wine_id"
#define RESTAURANT_ID @"restaurant_id"

@interface ServerHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObject *relatedObject;

-(void)getDataAtUrl:(NSString *)url;
-(void)processJSON:(id)json withRelatedObject:(NSManagedObject *)relatedObject;

-(NSManagedObject *)findOrCreateManagedObjectEntityType:(NSString *)entityName andIdentifier:(NSNumber *)identifier;

-(NSSet *)addRelationToSet:(NSSet *)set;

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary;

@end
