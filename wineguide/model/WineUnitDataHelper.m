//
//  WineUnitDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 11/6/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineUnitDataHelper.h"
#import "WineUnit+CreateAndModify.h"
#import "Group.h"
#import "Flight.h"
#import "GroupDataHelper.h"
#import "FlightDataHelper.h"
#import "WineDataHelper.h"

#define GROUP @"Group"
#define FLIGHT @"Flight"
#define WINE @"Wine"

@implementation WineUnitDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    return [WineUnit wineUnitFoundUsingPredicate:[self predicateForDicitonary:dictionary] inContext:self.context withEntityInfo:dictionary];
}


-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    if([managedObject isKindOfClass:[WineUnit class]]){
        WineUnit *wineUnit = (WineUnit *)managedObject;
        
        if([self.relatedObject class] == [Restaurant class]){
            wineUnit.wine = (Wine *)self.relatedObject;
            
        } else if([self.relatedObject class] == [Flight class]){
            wineUnit.flights = [self addRelationToSet:wineUnit.flights];
            
        } else if ([self.relatedObject class] == [Group class]){
            wineUnit.groups = [self addRelationToSet:wineUnit.groups];
        }
    }
}

-(void)createWineUnitWithIdentifier:(NSString *)identifier price:(NSNumber *)price quantity:(NSString *)quantity flightIdentifiers:(NSString *)flightIdentifiers groupIdentifiers:(NSString *)groupIdentifiers andWineIdentifier:(NSString *)wineIdentifier
{
    NSMutableDictionary *wineUnitDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"lastUpdated" : [NSDate date]}];
    
    if(identifier) [wineUnitDictionary setObject:identifier forKey:@"identifier"];
    if(price) [wineUnitDictionary setObject:price forKey:@"price"];
    if(quantity) [wineUnitDictionary setObject:quantity forKey:@"quantity"];
    if(flightIdentifiers) [wineUnitDictionary setObject:flightIdentifiers forKey:@"flightIdentifiers"];
    if(groupIdentifiers) [wineUnitDictionary setObject:groupIdentifiers forKey:@"groupIdentifiers"];
    if(wineIdentifier) [wineUnitDictionary setObject:wineIdentifier forKey:@"wineIdentifier"];
    
    NSLog(@"groupIdentifiers %@",groupIdentifiers);
    NSLog(@"wineIdentifier %@",wineIdentifier);
    
    [self updateManagedObjectWithDictionary:wineUnitDictionary];
}




@end
