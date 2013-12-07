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
#define LAST_SERVER_UPDATE @"lastServerUpdate"
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
    
    NSMutableDictionary *identifiers = [[NSMutableDictionary alloc] init];
    
    NSDate *dictionaryLastUpdatedDate = [varietal lastUpdatedDateFromDictionary:dictionary];
    
    if(!varietal.lastServerUpdate || [varietal.lastServerUpdate laterDate:dictionaryLastUpdatedDate] == dictionaryLastUpdatedDate){
        
        // ATTRIBUTES
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            varietal.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            varietal.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            varietal.about = [dictionary sanitizedStringForKey:ABOUT];
            varietal.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            varietal.isPlaceholderForFutureObject = @NO;
            varietal.lastServerUpdate = dictionaryLastUpdatedDate;
            varietal.deletedEntity = [dictionary sanitizedValueForKey:DELETED_ENTITY];
            varietal.name = [dictionary sanitizedStringForKey:NAME];
            varietal.versionNumber = [dictionary sanitizedValueForKey:VERSION_NUMBER];
            
            // store any information about relationships provided
            
            NSString *wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
            varietal.wineIdentifiers = [varietal addIdentifiers:wineIdentifiers toCurrentIdentifiers:varietal.wineIdentifiers];
            if(wineIdentifiers) [identifiers setObject:wineIdentifiers forKey:WINE_IDENTIFIERS];
        }
        
        [varietal updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
        
    } else if([varietal.lastServerUpdate isEqualToDate:dictionaryLastUpdatedDate]){
        [varietal updateRelationshipsUsingDictionary:dictionary identifiersDictionary:identifiers andContext:context];
    }
    
    //[varietal logDetails];
    
    return varietal;
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
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"about = %@",self.about);
    NSLog(@"lastLocalUpdate = %@",self.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",self.lastServerUpdate);
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
