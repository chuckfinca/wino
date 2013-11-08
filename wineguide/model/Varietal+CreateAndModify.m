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

#define VARIETAL_ENTITY @"Varietal"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define VERSION @"version"
#define NAME @"name"

@implementation Varietal (CreateAndModify)

+(Varietal *)varietalForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary

{
    Varietal *varietal = nil;
    
    varietal = (Varietal *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:VARIETAL_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(varietal){
        
        // ATTRIBUTES
        
        varietal.about = [dictionary objectForKeyNotNull:ABOUT];
        varietal.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // varietal.lastAccessed
        varietal.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        varietal.name = [dictionary objectForKeyNotNull:NAME];
        varietal.version = [dictionary objectForKeyNotNull:VERSION];
        
        
        // RELATIONSHIPS
        
        NSMutableSet *wines = [varietal.wines mutableCopy];
        if(![wines containsObject:wine]) [wines addObject:wine];
        varietal.wines = wines;
    }
    
    [varietal logDetails];
    
    return varietal;
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
    
    NSLog(@"wines count = %i",[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@" = %@",obj.description);
    }
    NSLog(@"\n\n\n");
}






@end
