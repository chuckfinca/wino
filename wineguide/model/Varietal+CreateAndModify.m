//
//  Varietal+CreateAndModify.m
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Varietal+CreateAndModify.h"
#import "ManagedObjectHandler.h"
#import "NSDictionary+Helper.h"
#import "NSManagedObject+Helper.h"
#import "WineDataHelper.h"

#define VARIETAL_ENTITY @"Varietal"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define IS_PLACEHOLDER @"isPlaceholderForFutureObject"
#define LAST_UPDATED @"lastUpdated"
#define DELETED_ENTITY @"deletedEntity"
#define VERSION_NUMBER @"versionNumber"
#define NAME @"name"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

@implementation Varietal (CreateAndModify)

+(Varietal *)varietalFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary

{
    Varietal *varietal = nil;
    
    varietal = (Varietal *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:VARIETAL_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    NSString *wineIdentifiers;
    
    NSLog(@"self = %@",self);
    NSLog(@"lastUpdated = %@",varietal.lastUpdated);
    NSLog(@"dictionary[LAST_UPDATED] = %@",dictionary[LAST_UPDATED]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss Z"];
    NSDate *serverDate = [dateFormatter dateFromString:dictionary[LAST_UPDATED]];
    
    NSLog(@"serverDate = %@",serverDate);
    if(!varietal.lastUpdated || [varietal.lastUpdated laterDate:serverDate] == serverDate){
        NSLog(@"inside");
        
        // ATTRIBUTES
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            varietal.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            varietal.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            varietal.about = [dictionary sanitizedStringForKey:ABOUT];
            varietal.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            varietal.isPlaceholderForFutureObject = @NO;
            varietal.lastUpdated = [NSDate date];
            varietal.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            varietal.name = [dictionary sanitizedStringForKey:NAME];
            varietal.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
            varietal.wineIdentifiers = [varietal addIdentifiers:wineIdentifiers toCurrentIdentifiers:varietal.wineIdentifiers];
        }
    }
    
    // RELATIONSHIPS
    // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
    
    // Wines
    WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:varietal andNeededManagedObjectIdentifiersString:wineIdentifiers];
    [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    
    //[varietal logDetails];
    
    return varietal;
}


-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"about = %@",self.about);
    NSLog(@"lastUpdated = %@",self.lastUpdated);
    NSLog(@"deletedEntity = %@",self.deletedEntity);
    NSLog(@"name = %@",self.name);
    NSLog(@"versionNumber = %@",self.versionNumber);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %lu",(unsigned long)[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}






@end
