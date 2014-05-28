//
//  User2+Modify.h
//  Corkie
//
//  Created by Charles Feinn on 4/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "User2.h"

#define USER_EMAIL @"email"
#define USER_GENDER @"gender"
#define USER_LATITUDE @"user_latitude"
#define USER_LONGITUDE @"user_longitude"
#define USER_NAME_FIRST @"user_first"
#define USER_NAME_LAST @"user_last"
#define USER_IMAGE @"image"
#define USER_FACEBOOK_ID @"facebook_id"
#define USER_FACEBOOK_UPDATED_AT @"facebook_updated_at"

@interface User2 (Modify)

-(User2 *)modifyAttributesWithDictionary:(NSDictionary *)dictionary;

@end
