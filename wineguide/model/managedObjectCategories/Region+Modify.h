//
//  Region+Modify.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Region.h"

@interface Region (Modify)

-(Region *)modifyAttributesWithDictionary:(NSDictionary *)dictionary;

@end
