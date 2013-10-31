//
//  JSONParser.m
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

-(void)prepareJSONatURL:(NSURL *)url
{
    NSLog(@"prepareJSON...");
    dispatch_queue_t jsonQueue = dispatch_queue_create("JSON_Queue", NULL);
    dispatch_async(jsonQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(dictionaryFromJSONData:) withObject:data];
        });
    });
}

-(void)dictionaryFromJSONData:(NSData *)data
{
    NSLog(@"parseJsonData...");
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    NSLog(@"json = %@",json);
    NSLog(@"data = %i",data.length);
}

-(void)updateRestaurantsInCoreDataWithDictionary:(NSDictionary *)dictionary
{
    
}







@end
