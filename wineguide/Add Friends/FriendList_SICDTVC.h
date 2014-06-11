//
//  FriendListSCDTVC.h
//  Corkie
//
//  Created by Charles Feinn on 3/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Searchable_ICDTVC.h"
#import "User2.h"

@interface FriendList_SICDTVC : Searchable_ICDTVC

@property (nonatomic, strong) User2 *user;
@property (nonatomic, strong) NSPredicate *predicate;

@end
