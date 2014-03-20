//
//  UserDataHelper.m
//  Corkie
//
//  Created by Charles Feinn on 3/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UserDataHelper.h"
#import "User+CreateAndModify.h"

@implementation UserDataHelper

-(NSManagedObject *)updateManagedObjectWithDictionary:(NSDictionary *)dictionary
{
    NSString *identifier = [dictionary objectForKey:@"id"];
    NSLog(@"- identifer = %@",identifier);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",identifier];
    
    User *u = [User userFoundUsingPredicate:predicate inContext:self.context withEntityInfo:dictionary];
    
    return u;
}


@end
