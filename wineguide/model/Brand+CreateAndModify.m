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
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define VERSION @"version"
#define WEBSITE @"website"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

+(Brand *)brandFoundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Brand *brand = nil;
    
    brand = (Brand *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:BRAND_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(brand){
        
        if([[dictionary sanitizedValueForKey:IS_PLACEHOLDER] boolValue] == YES){
            
            brand.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
            brand.isPlaceholderForFutureObject = @YES;
            
        } else {
            
            if([brand.version intValue] == 0 || brand.version < dictionary[VERSION]){
                
                // ATTRIBUTES
                
                brand.about = [dictionary sanitizedStringForKey:ABOUT];
                brand.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
                brand.isPlaceholderForFutureObject = @NO;
                // brand.lastAccessed
                brand.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
                brand.name = [dictionary sanitizedStringForKey:NAME];
                brand.version = [dictionary sanitizedValueForKey:VERSION];
                brand.website = [dictionary sanitizedStringForKey:WEBSITE];
                
                // store any information about relationships provided
                
                NSString *wineIdentifiers = [dictionary sanitizedStringForKey:WINE_IDENTIFIERS];
                brand.wineIdentifiers = [brand addIdentifiers:wineIdentifiers toCurrentIdentifiers:brand.wineIdentifiers];
                
                
                // RELATIONSHIPS
                // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
                
                // Wines
                WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context andRelatedObject:brand andNeededManagedObjectIdentifiersString:wineIdentifiers];
                [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
            }
        }
    }
    
    //[brand logDetails];
    
    return brand;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"about = %@",self.about);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"isPlaceholderForFutureObject = %@",self.isPlaceholderForFutureObject);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"name = %@",self.name);
    NSLog(@"version = %@",self.version);
    NSLog(@"website = %@",self.website);
    NSLog(@"wineIdentifiers = %@",self.wineIdentifiers);
    
    NSLog(@"wines count = %i",[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
