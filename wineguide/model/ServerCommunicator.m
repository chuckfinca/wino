//
//  ServerCaller.m
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ServerCommunicator.h"
#import "RestaurantHelper.h"
#import "DocumentHandler2.h"
#import "WineHelper.h"
#import "WineListHelper.h"

@interface ServerCommunicator ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ServerCommunicator

#pragma mark - Getters & setters

-(NSManagedObjectContext *)context
{
    if(!_context){
        _context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
    }
    return _context;
}

-(void)getRestaurantsNearLatitude:(double)latitude longitude:(double)longitude
{
    // call Corkie server and get restaurant json
    
    
    NSURL *restaurantsJSONUrl = [[NSBundle mainBundle] URLForResource:@"restaurants2" withExtension:@"json"];
    /*
     NSString *restaurantsURLString = @"http://www.corkieapp.com/nearMe/1/1";
    NSLog(@"%@",[NSString stringWithFormat:@"http://www.corkieapp.com/nearMe/%f/%f",longitude,latitude]);
     */
    
    RestaurantHelper *restaurantHelper = [[RestaurantHelper alloc] init];
    [restaurantHelper getDataAtUrl:[restaurantsJSONUrl absoluteString]];
}

-(void)getAllWinesFromRestaurantIdentifier:(NSInteger)restaurantIdentifier
{
    WineListHelper *wlh = [[WineListHelper alloc] init];
    [wlh getDataAtUrl:[NSString stringWithFormat:@"http://www.corkieapp.com/getWineList/%ld",(long)restaurantIdentifier]];
    NSLog(@"%@",[NSString stringWithFormat:@"http://www.corkieapp.com/getWineList/%ld",(long)restaurantIdentifier]);
}

@end
