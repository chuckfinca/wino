//
//  FriendListSCDTVC.h
//  Corkie
//
//  Created by Charles Feinn on 3/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SearchableCDTVC.h"
#import "User.h"

@protocol FriendSelectionDelegate

-(void)addOrRemoveUser:(User *)user;

@end

@interface FriendListSCDTVC : SearchableCDTVC

@property (nonatomic, weak) id <FriendSelectionDelegate> delegate;

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text;

@end
