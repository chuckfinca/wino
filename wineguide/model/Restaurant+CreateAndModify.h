//
//  Restaurant+Create.h
//  wineguide
//
//  Created by Charles Feinn on 10/29/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Restaurant.h"

@interface Restaurant (CreateAndModify)

+(Restaurant *)restaurantWithInfo:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;


@end
