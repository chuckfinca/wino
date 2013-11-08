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

@implementation Brand (CreateAndModify)

#define BRAND_ENTITY @"Brand"

#define ABOUT @"about"
#define IDENTIFIER @"identifier"
#define MARK_FOR_DELETION @"markForDeletion"
#define NAME @"name"
#define VERSION @"version"
#define WEBSITE @"website"

+(Brand *)brandForWine:(Wine *)wine foundUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context withEntityInfo:(NSDictionary *)dictionary
{
    Brand *brand = nil;
    
    brand = (Brand *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:BRAND_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
    
    if(brand){
        
        // ATTRIBUTES
        
        brand.about = [dictionary objectForKeyNotNull:ABOUT];
        brand.identifier = [dictionary objectForKeyNotNull:IDENTIFIER];
        // brand.lastAccessed
        brand.markForDeletion = [dictionary objectForKeyNotNull:MARK_FOR_DELETION];
        brand.name = [dictionary objectForKeyNotNull:NAME];
        brand.version = [dictionary objectForKeyNotNull:VERSION];
        brand.website = [dictionary objectForKeyNotNull:WEBSITE];
        
        
        // RELATIONSHIPS
        
        NSMutableSet *wines = [brand.wines mutableCopy];
        if(![wines containsObject:wine]) [wines addObject:wine];
        brand.wines = wines;
    }
    
    [brand logDetails];
    
    return brand;
}

-(NSString *)description
{
    return self.identifier;
}

-(void)logDetails
{
    NSLog(@"----------------------------------------");
    NSLog(@"about = %@",self.about);
    NSLog(@"identifier = %@",self.identifier);
    NSLog(@"lastAccessed = %@",self.lastAccessed);
    NSLog(@"markForDeletion = %@",self.markForDeletion);
    NSLog(@"name = %@",self.name);
    NSLog(@"version = %@",self.version);
    NSLog(@"website = %@",self.website);
    
    NSLog(@"wines count = %i",[self.wines count]);
    for(NSObject *obj in self.wines){
        NSLog(@"  %@",obj.description);
    }
    NSLog(@"\n\n\n");
}

@end
