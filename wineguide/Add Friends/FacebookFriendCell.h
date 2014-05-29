//
//  FacebookFriendCell.h
//  Corkie
//
//  Created by Charles Feinn on 5/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User2.h"

@interface FacebookFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

-(void)setupForUser:(User2 *)user;

@end
