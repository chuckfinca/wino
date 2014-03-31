//
//  NSManagedObject+Helper.m
//  wineguide
//
//  Created by Charles Feinn on 11/9/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "NSManagedObject+Helper.h"
#import "NSDictionary+Helper.h"

#define LAST_UPDATED @"lastUpdated"
#define INITIAL_DATE @"2013-12-05 00:17:54 +0000"
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

-(NSDate *)lastUpdatedDateFromDictionary:(NSDictionary *)dictionary
{
    NSDate *dictionaryUpdatedDate;
    
    if([dictionary[LAST_UPDATED] isKindOfClass:[NSString class]]){
        dictionaryUpdatedDate = [dictionary dateFromString:dictionary[LAST_UPDATED]];
        
    } else if([dictionary[LAST_UPDATED] isKindOfClass:[NSDate class]]){
        dictionaryUpdatedDate = dictionary[LAST_UPDATED];
        
    } else if(!dictionary[LAST_UPDATED]){
        dictionaryUpdatedDate = [NSDate date];
        
    } else {
        NSLog(@"ERROR - dictionary[LAST_UPDATED] isn't a NSString or NSDate");
        NSLog(@"it's %@",dictionary[LAST_UPDATED]);
        NSLog(@"a %@",[dictionary[LAST_UPDATED] class]);
    }
    // NSLog(@"dictionaryLastUpdatedDate = %@",dictionaryUpdatedDate);
    return dictionaryUpdatedDate;
}


-(NSDate *)dateFromObj:(id)obj
{
    NSDate *date;
    
    if([obj isKindOfClass:[NSDate class]]){
        date = (NSDate *)obj;
    } else if([obj isKindOfClass:[NSString class]]){
        NSDictionary *dictionary;
        date = [dictionary dateFromString:(NSString *)obj];
    }
    return date;
}












@end
