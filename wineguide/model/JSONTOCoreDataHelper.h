//
//  JSONDataHelper.h
//  wineguide
//
//  Created by Charles Feinn on 10/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONTOCoreDataHelper : NSObject

-(id)initWithContext:(NSManagedObjectContext *)context; // designated initializer
-(void)updateCoreDataWithJSONFromURL:(NSURL *)url;

-(void)updateManagedObjectWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context; // abstract

@end
