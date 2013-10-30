//
//  Restaurant+Create.h
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant.h"

@interface Restaurant (Create)

-(void)modifyBasicInfoWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;
-(void)modifyWinesWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
