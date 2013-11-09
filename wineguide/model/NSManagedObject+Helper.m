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
        currentIdentifiers = [currentIdentifiers stringByAppendingString:[NSString stringWithFormat:@"%@%@",DIVIDER,newIdentifiers]];
    }
    
    return currentIdentifiers;
}


-(NSString *)description
{
    return self.identifier;
}

@end
