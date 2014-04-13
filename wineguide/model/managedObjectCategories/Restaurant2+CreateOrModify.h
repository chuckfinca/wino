//
//  Restaurant2+CreateOrModify.h
//  Corkie
//
//  Created by Charles Feinn on 4/12/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Restaurant2.h"

@interface Restaurant2 (CreateOrModify)

-(Restaurant2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary;

@end
