//
//  GetMe.m
//  Corkie
//
//  Created by Charles Feinn on 4/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "GetMe.h"
#import "DocumentHandler.h"

#define USER_ENTITY @"User"

@implementation GetMe

static DocumentHandler *instance;

+(DocumentHandler *)sharedInstance
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(User *)me
{
    if(!_me){
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"isMe = YES"];
        
        NSError *error;
        NSArray *matches = [[DocumentHandler sharedDocumentHandler].document.managedObjectContext executeFetchRequest:request error:&error];
        
        if([matches count] > 0){
            _me = [matches firstObject];
        } else {
            NSLog(@"Me not found!");
        }
    }
    return _me;
}

@end
