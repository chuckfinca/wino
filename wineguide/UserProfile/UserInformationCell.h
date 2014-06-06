//
//  UserInformationCell.h
//  Corkie
//
//  Created by Charles Feinn on 6/5/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User2.h"

@protocol ToggleFollowingButtonDelegate

-(void)toggleFollowing;

@end

@interface UserInformationCell : UITableViewCell

@property (nonatomic, weak) id <ToggleFollowingButtonDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (nonatomic) BOOL isFollowing;

-(void)setupForUser:(User2 *)user;
-(void)setupFollowButton;

@end
