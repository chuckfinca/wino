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

// if location services have not been enabled yet
// user enables location

// at start of app OR after location services have been enabled
    // get users location
    // compare location with stored location
    // if no stored location OR stored location is different than user's location then ask server for restaurants in the users area/city
        // once downloaded store the restaurant data in db
    // use local restaurant info to get/display the restaurants near the user

// when on the list page we should download the wine menus for the closest 3? restaurants







@end
