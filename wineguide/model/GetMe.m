//
//  GetMe.m
//  Corkie
//
//  Created by Charles Feinn on 4/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "GetMe.h"
#import "DocumentHandler2.h"
#import "ManagedObjectHandler.h"

#define USER_ENTITY @"User2"
#define IDENTIFIER @"identifier"

@implementation GetMe

static GetMe *instance;

+(GetMe *)sharedInstance
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(User2 *)me
{
    if(!_me){
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"is_me = YES"];
        
        NSManagedObjectContext *context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if([matches count] > 0){
            _me = [matches firstObject];
        } else {
            
            // create non-facebook connected user
            NSNumber *identifier = @0;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",identifier];
            NSDictionary *dictionary = @{IDENTIFIER : identifier};
            
            _me = (User2 *)[ManagedObjectHandler createOrReturnManagedObjectWithEntityName:USER_ENTITY usingPredicate:predicate inContext:context usingDictionary:dictionary];
            _me.identifier = identifier;
            _me.is_me = @YES;
        }
        if(!_me.name_display){
            _me.name_display = @"Me";
        }
        
    }
    return _me;
}

@end
