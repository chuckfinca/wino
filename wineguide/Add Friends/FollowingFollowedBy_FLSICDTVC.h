//
//  FollowingFollowedBy_FLSICDTVC.h
//  Corkie
//
//  Created by Charles Feinn on 6/10/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendList_SICDTVC.h"

@interface FollowingFollowedBy_FLSICDTVC : FriendList_SICDTVC

-(id)initWithUser:(User2 *)user predicate:(NSPredicate *)predicate andPageTitle:(NSString *)title;

@end
