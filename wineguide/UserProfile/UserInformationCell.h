//
//  UserInformationCell.h
//  Corkie
//
//  Created by Charles Feinn on 6/5/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User2.h"

@interface UserInformationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

-(void)setupForUser:(User2 *)user;

@end
