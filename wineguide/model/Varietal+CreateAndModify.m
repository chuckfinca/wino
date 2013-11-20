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
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define NAME @"name"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

@implementation Varietal (CreateAndModify)

+(Varietal *)varietalFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary

{
    Varietal *varietal = nil;
    
    varietal = (Varietal *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:VARIETAL_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(varietal){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            varietal.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            varietal.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            if([varietal.version intValue] == 0 || varietal.version < dictionary[VERSION]){
                
                // ATTRIBUTES
                
                varietal.about = [dictionary sanitizedStringForKey:ABOUT];
                varietal.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
                varietal.isPlaceholderForFutureObject = @NO;
                // varietal.lastAccessed
                varietal.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
                varietal.name = [dictionary sanitizedStringForKey:NAME];
                varietal.version = [dictionary sanitizedValueForKey:VERSION];
                
                // store any information about relationships provided
                
                NSString *wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
                varietal.wineIdentifiers = [varietal addIdentifiers:wineIdentifiers toCurrentIdentifiers:varietal.wineIdentifiers];
                
                
                // RELATIONSHIPS
                // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
                
                // Wines
                WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:varietal andNeededManagedObjectIdentifiersString:wineIdentifiers];
                [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
            }
        }
    }
    
    [varietal logDetails];
    
    return varietal;
}


-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"about = %@",self.about);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"name = %@",self.name);
    NSLog(@"version = %@",self.version);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %i",[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}






@end
