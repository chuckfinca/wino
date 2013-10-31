//
//  JSONParser.h
//  wineguide
//
//  Created by Charles Feinn on 10/30/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantDataHelper : NSObject

-(id)initWithContext:(NSManagedObjectContext *)context; // designated initializer

-(void)updatedRestaurantsWithJSONDataFromURL:(NSURL *)url;

@end
