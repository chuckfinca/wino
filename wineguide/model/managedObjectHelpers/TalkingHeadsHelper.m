//
//  TalkingHeadsHelper.m
//  Corkie
//
//  Created by Charles Feinn on 5/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TalkingHeadsHelper.h"
#import "TalkingHeads+Modify.h"
#import "UserHelper.h"
#import "User2.h"
#import "WineHelper.h"
#import "Wine2.h"

#define TALKING_HEADS_USERS @"users"                       ///////////////////
#define TALKING_HEADS_WINE @"wine"                         ///////////////////

@implementation TalkingHeadsHelper


-(NSManagedObject *)createOrModifyObjectWithDictionary:(NSDictionary *)dictionary
{
    TalkingHeads *talkingHeads = (TalkingHeads *)[self findOrCreateManagedObjectEntityType:REVIEW_ENTITY usingDictionary:dictionary];
    [talkingHeads modifyAttributesWithDictionary:dictionary];
    
    return talkingHeads;
}

-(void)addRelationToManagedObject:(NSManagedObject *)managedObject
{
    TalkingHeads *talkingHeads = (TalkingHeads *)managedObject;
    
    if([self.relatedObject class] == [Wine2 class]){
        talkingHeads.wine = (Wine2 *)self.relatedObject;
        
    } else if([self.relatedObject class] == [User2 class]){
        [self addRelationToSet:talkingHeads.users];
    }
}

-(void)processManagedObject:(NSManagedObject *)managedObject relativesFoundInDictionary:(NSDictionary *)dictionary
{
    TalkingHeads *talkingHeads = (TalkingHeads *)managedObject;
    
    // Wine
    if(!talkingHeads.wine){
        WineHelper *wh = [[WineHelper alloc] init];
        [wh processJSON:dictionary[TALKING_HEADS_WINE] withRelatedObject:talkingHeads];
    }
    
    // User
    UserHelper *uh = [[UserHelper alloc] init];
    [uh processJSON:dictionary[TALKING_HEADS_USERS] withRelatedObject:talkingHeads];
    
}






@end
