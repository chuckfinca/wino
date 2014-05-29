//
//  FacebookFriendCell.m
//  Corkie
//
//  Created by Charles Feinn on 5/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookFriendCell.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@interface FacebookFriendCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation FacebookFriendCell

- (void)awakeFromNib
{
    // Initialization code
    self.userProfileImageView.backgroundColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupForUser:(User2 *)user
{
    if(user.name_display){
        NSString *name = [NSString stringWithFormat:@"%@ ",user.name_first];
        NSInteger firstNameLength = [name length];
        name = [name stringByAppendingString:user.name_last];
        
        NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body}];
        [attributedName addAttribute:NSFontAttributeName value:[FontThemer sharedInstance].headline range: NSMakeRange(firstNameLength, [user.name_last length])];
        
        self.userNameLabel.attributedText = attributedName;
        
        self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    }
}

@end
