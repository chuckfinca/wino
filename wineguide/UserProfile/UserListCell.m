//
//  UserListCell.m
//  Corkie
//
//  Created by Charles Feinn on 6/11/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UserListCell.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@implementation UserListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setupUserInteractionEnabled:(BOOL)userInteractionEnabled cellWithTitle:(NSString *)title
{
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    
    if(userInteractionEnabled){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.userInteractionEnabled = NO;
    }
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

@end
