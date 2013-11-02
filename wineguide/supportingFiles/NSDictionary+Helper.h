//
//  NSDictionary+Helper.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)

-(id)objectForKeyNotNull:(id)key;

-(NSArray *)separateNonNullStringLocatedAtKey:(NSString *)key;

@end
