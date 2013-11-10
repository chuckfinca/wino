//
//  NSManagedObject+Helper.m
//  wineguide
//
//  Created by Charles Feinn on 11/9/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "NSManagedObject+Helper.h"

#define DIVIDER @"/"


@implementation NSManagedObject (Helper)

@dynamic identifier;

-(NSString *)addIdentifiers:(NSString *)newIdentifiers toCurrentIdentifiers:(NSString *)currentIdentifiers
{
    if(!currentIdentifiers){
        currentIdentifiers = newIdentifiers;
    } else {
        NSSet *currentIdentifierSet = [[NSSet alloc] initWithArray:[currentIdentifiers componentsSeparatedByString:DIVIDER]];
        NSArray *identifiersFromServer = [newIdentifiers componentsSeparatedByString:DIVIDER];
        
        NSString *identifiersToAdd = @"";
        for(NSString *i in identifiersFromServer){
            if(![currentIdentifierSet containsObject:i]){
                identifiersToAdd = [identifiersToAdd stringByAppendingString:[NSString stringWithFormat:@"%@%@",DIVIDER,i]];
            }
        }
        if(![identifiersToAdd  isEqual: @""]) currentIdentifiers = [currentIdentifiers stringByAppendingString:[NSString stringWithFormat:@"%@%@",DIVIDER,identifiersToAdd]];
    }
    
    return currentIdentifiers;
}


-(NSString *)description
{
    return self.identifier;
}

@end
