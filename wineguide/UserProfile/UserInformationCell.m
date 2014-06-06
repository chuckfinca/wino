//
//  UserInformationCell.m
//  Corkie
//
//  Created by Charles Feinn on 6/5/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UserInformationCell.h"
#import "GetMe.h"
#import "FontThemer.h"
#import "ColorSchemer.h"
#import "UIView+BorderDrawer.h"

@interface UserInformationCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToUserProfileImageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userProfileImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userProfileImageViewToUserNameLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelToFollowButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followButtonToBottomConstraint;
@end

@implementation UserInformationCell

-(void)setupForUser:(User2 *)user
{
    if(user.name_display){
        self.userNameLabel.attributedText = [[NSAttributedString alloc] initWithString:user.name_display attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    }
    
    if([user.followedBy containsObject:[GetMe sharedInstance].me]){
        self.isFollowing = YES;
    }
    [self setupFollowButton];
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customWhite;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:YES bottom:YES left:NO andRight:NO];
}

-(void)setIsFollowing:(BOOL)isFollowing
{
    _isFollowing = isFollowing;
    [self setupFollowButton];
}

-(void)setupFollowButton
{
    NSString *followButtonText;
    if(self.isFollowing){
        followButtonText = @"Unfollow";
    } else {
        followButtonText = @"Follow";
    }
    [self.followButton setAttributedTitle:[[NSAttributedString alloc] initWithString:followButtonText attributes:[FontThemer sharedInstance].linkCaption1TextAttributes] forState:UIControlStateNormal];
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToUserProfileImageViewConstraint.constant;
    height += self.userProfileImageViewHeightConstraint.constant;
    height += self.userProfileImageViewToUserNameLabelConstraint.constant;
    
    CGSize userNameLabelSize = [self.userNameLabel sizeThatFits:CGSizeMake(self.userNameLabel.bounds.size.width, FLT_MAX)];
    height += userNameLabelSize.height;
    
    height += self.userNameLabelToFollowButtonConstraint.constant;
    
    CGSize followButtonSize = [self.followButton sizeThatFits:CGSizeMake(self.followButton.bounds.size.width, FLT_MAX)];
    height += followButtonSize.height;
    
    height += self.followButtonToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

#pragma mark - Target action


-(IBAction)toggleFollowingButton:(id)sender
{
    [self.delegate toggleFollowing];
}


@end
