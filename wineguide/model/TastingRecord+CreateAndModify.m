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

+(TastingRecord *)foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    TastingRecord *tastingRecord;
    
    tastingRecord = (TastingRecord *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:TASTING_RECORD_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSDate *updatedDate = [tastingRecord lastUpdatedDateFromDictionary:dictionary];
    
    if(!tastingRecord.addedDate || [tastingRecord.updatedDate laterDate:updatedDate] == updatedDate){
        
        // ATTRIBUTES
        
        NSDate *addedDate = [tastingRecord dateFromObj:dictionary[ADDED_DATE]];
        if(addedDate){
            tastingRecord.addedDate = addedDate;
        } else {
            tastingRecord.addedDate = updatedDate;
        }
        
        tastingRecord.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
        tastingRecord.identifier = [dictionary sanitizedStringForKey:IDENTIFIER];
        
        NSDate *tastingDate = [tastingRecord dateFromObj:dictionary[TASTING_DATE]];
        if(tastingDate){
            tastingRecord.tastingDate = tastingDate;
        } else if(!tastingRecord.tastingDate){
            tastingDate = updatedDate;
        }
        
        tastingRecord.updatedDate = updatedDate;
        
        [tastingRecord logDetails];
        
    }    return tastingRecord;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"added date = %@",self.addedDate);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"tasting Date = %@",self.tastingDate);
    NSLog(@"updatedDate = %@",self.updatedDate);
    
    
    NSLog(@"\n\n\n");
}





@end
