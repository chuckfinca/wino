//
//  JSONDataHelper.m
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "JSONTOCoreDataHelper.h"

@interface JSONTOCoreDataHelper ()

@property (nonatomic, weak) NSManagedObjectContext *context;

@end


@implementation JSONTOCoreDataHelper

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    _context = context;
    return self;
}

-(void)updateCoreDataWithJSONFromURL:(NSURL *)url
{
    dispatch_queue_t jsonQueue = dispatch_queue_create("JSON_Queue", NULL);
    dispatch_async(jsonQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(json){
                [self updateCoreDataWithDictionaryObjectsInDictionary:json];
            } else {
                NSLog(@"json does not exist!");
            }
        });
    });
}



-(void)updateCoreDataWithDictionaryObjectsInDictionary:(NSDictionary *)dictionary
{
    if(self.context){
        for(NSDictionary *restaurantInfo in dictionary){
            [self updateManagedObjectWithDictionary:restaurantInfo inContext:self.context];
        }
    } else {
        NSLog(@"DataHelper context = nil");
    }
}

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    // abstract
}

@end
