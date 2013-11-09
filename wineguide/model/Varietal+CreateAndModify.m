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
#import "WineDataHelper.h"

#define VARIETAL_ENTITY @"Varietal"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define NAME @"name"
#define WINE_IDENTIFIERS @"wineIdentifiers"
#define WINES @"wines"

#define DIVIDER @"/"

@implementation Varietal (CreateAndModify)

+(Varietal *)varietalForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary

{
    Varietal *varietal = nil;
    
    varietal = (Varietal *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:VARIETAL_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(varietal){
        
        // ATTRIBUTES
        
        varietal.about = [dictionary sanitizedValueForKey:ABOUT];
        varietal.identifier = [dictionary sanitizedValueForKey:IDENTIFIER];
        // varietal.lastAccessed
        varietal.markForDeletion = [dictionary sanitizedValueForKey:MARK_FOR_DELETION];
        varietal.name = [dictionary sanitizedValueForKey:NAME];
        varietal.version = [dictionary sanitizedValueForKey:VERSION];
        
        // store any information about relationships provided
        
        [varietal addIdentifiers:[dictionary sanitizedValueForKey:WINE_IDENTIFIERS] toCurrentIdentifiers:varietal.wineIdentifiers];
        
        
        // RELATIONSHIPS
        // The JSON may or may not have returned a nested JSON for the following relationships. If it did then update these items with the nested JSON
        
        // Wines
        WineDataHelper *wdh = [[WineDataHelper alloc] initWithContext:context];
        wdh.parentManagedObject = varietal;
        [wdh updateNestedManagedObjectsLocatedAtKey:WINES inDictionary:dictionary];
    }
    
    [varietal logDetails];
    
    return varietal;
}

-(void)addIdentifiers:(NSString *)newIdentifiers toCurrentIdentifiers:(NSString *)currentIdentifiers
{
    if(!currentIdentifiers){
        currentIdentifiers = newIdentifiers;
    } else {
        currentIdentifiers = [currentIdentifiers stringByAppendingString:[NSString stringWithFormat:@"%@%@",DIVIDER,newIdentifiers]];
    }
}

-(NSString *)description
{
    return self.identifier;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",self.identifier);
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
