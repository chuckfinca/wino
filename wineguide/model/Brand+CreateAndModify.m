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
#define LAST_UPDATED @"lastUpdated"
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
    
    NSString *wineIdentifiers;
    
    NSLog(@"self = %@",self);
    NSLog(@"lastUpdated = %@",brand.lastUpdated);
    NSLog(@"dictionary[LAST_UPDATED] = %@",dictionary[LAST_UPDATED]);
    
    NSDate *serverDate = [dictionary dateFromString:dictionary[LAST_UPDATED]];
    
    NSLog(@"serverDate = %@",serverDate);
    if(!brand.lastUpdated || [brand.lastUpdated laterDate:serverDate] == serverDate){
        NSLog(@"inside");
        
        // ATTRIBUTES
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            brand.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            brand.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            brand.about = [dictionary sanitizedStringForKey:ABOUT];
            brand.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            brand.isPlaceholderForFutureObject = @NO;
            brand.lastUpdated = [NSDate date];
            brand.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            brand.name = [dictionary sanitizedStringForKey:NAME];
            brand.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            brand.website = [dictionary sanitizedStringForKey:WEBSITE];
            
            // store any information about relationships provided
            
            wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
            brand.wineIdentifiers = [brand addIdentifiers:wineIdentifiers toCurrentIdentifiers:brand.wineIdentifiers];
        }
    }
    
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:brand andNeededManagedObjectIdentifiersString:wineIdentifiers];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    
    //[brand logDetails];
    
    return brand;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"about = %@",self.about);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"website = %@",self.website);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %lu",(unsigned long)[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
