//
//  FriendListVC.h
//  Corkie
//
//  Created by Charles Feinn on 3/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckInFriends_FLSICDTVC.h"

@protocol FriendListVcDelegate

-(void)checkInWithFriends:(NSArray *)selectedFriendsArray;
-(void)backFromVC:(UIViewController *)dismissed withFriends:(NSArray *)selectedFriendsArray;

@end

@interface FriendListVC : UIViewController <FriendSelectionDelegate>

@property (nonatomic, weak) id <FriendListVcDelegate> delegate;

@property (nonatomic, strong) NSString *wineName;
@property (nonatomic, strong) NSMutableArray *selectedFriends;

@end
