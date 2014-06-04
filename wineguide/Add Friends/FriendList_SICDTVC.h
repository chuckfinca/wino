//
//  FriendListSCDTVC.h
//  Corkie
//
//  Created by Charles Feinn on 3/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Searchable_ICDTVC.h"
#import "User2.h"

@protocol FriendSelectionDelegate

-(void)addOrRemoveUser:(User2 *)user;
-(void)animateNavigationBarBarTo:(CGFloat)y;

@end

@interface FriendList_SICDTVC : Searchable_ICDTVC

@property (nonatomic, weak) id <FriendSelectionDelegate> delegate;

@end
