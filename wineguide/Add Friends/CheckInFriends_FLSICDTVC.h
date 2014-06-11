//
//  CheckInFriends_FLSICDTVC.h
//  Corkie
//
//  Created by Charles Feinn on 6/10/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendList_SICDTVC.h"

@protocol FriendSelectionDelegate

-(void)addOrRemoveUser:(User2 *)user;
-(void)animateNavigationBarBarTo:(CGFloat)y;

@end

@interface CheckInFriends_FLSICDTVC : FriendList_SICDTVC

@property (nonatomic, weak) id <FriendSelectionDelegate> delegate;

@end
