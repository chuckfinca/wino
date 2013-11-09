//
//  NSDictionary+Helper.h
//  wineguide
//
//  Created by Charles Feinn on 11/1/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)

-(id)sanitizedValueForKey:(id)key;
-(id)sanatizedStringForKey:(id)key;

-(NSArray *)separateNonNullStringLocatedAtKey:(NSString *)key;

@end
