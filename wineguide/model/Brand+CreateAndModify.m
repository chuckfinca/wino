//
//  Brand+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Brand+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "WineDataHelper.h"

@implementation Brand (CreateAndModify)

#define BRAND_ENTITY @"Brand"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_SERVER_UPDATE @"lastServerUpdate"
#define DELETED_ENTITY @"deletedEntity"
#define NAME @"name"
#define VERSION_NUMBER @"versionNumber"
#define WEBSITE @"website"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

+(Brand *)brandFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Brand *brand = nil;
    
    brand = (Brand *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:BRAND_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [brand lastUpdatedDateFromDictionary:dictionary];
    
    if(!brand.lastServerUpdate || [brand.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        // ATTRIBUTES
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            brand.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            brand.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            brand.about = [dictionary sanitizedStringForKey:ABOUT];
            brand.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            brand.isPlaceholderForFutureObject = @NO;
            brand.lastServerUpdate = dictionaryLastUpdatedDate;
            brand.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            brand.name = [dictionary sanitizedStringForKey:NAME];
            brand.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            brand.website = [dictionary sanitizedStringForKey:WEBSITE];
            
            // store any information about relationships provided
            
            NSString *wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
            brand.wineIdentifiers = [brand addIdentifiers:wineIdentifiers toCurrentIdentifiers:brand.wineIdentifiers];
            if(wineIdentifiers) [identifiers setObject:wineIdentifiers forKey:WINE_IDENTIFIERS];
        }
        
        [brand updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([brand.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [brand updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    //[brand logDetails];
    
    return brand;
}



-(void)updateRelationshipsUsingDictionary:(NSDictionary *)dictionary identifiersDictionary:(NSDictionary *)identifiers andContext:(NSManagedObjectContext *)context
{
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:self andNeededManagedObjectIdentifiersString:identifiers[WINE_IDENTIFIERS]];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"about = %@",self.about);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"website = %@",self.website);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %lu",(unsigned long)[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
