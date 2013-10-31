//
//  Restaurant+Create.h
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant.h"

@interface Restaurant (Create)

+(Restaurant *)restaurantWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;
-(void)modifyBasicInfoWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

// should this be here? maybe the wine category should handle the connecting of a wine to a restaurant...
-(void)modifyWinesWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
