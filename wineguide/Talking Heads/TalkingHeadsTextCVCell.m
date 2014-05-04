//
//  TalkingHeadsTextCVCell.m
//  Corkie
//
//  Created by Charles Feinn on 5/2/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TalkingHeadsTextCVCell.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@interface TalkingHeadsTextCVCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TalkingHeadsTextCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupForNumberOfPeople:(NSInteger)numberOfPeople includingYou:(BOOL)youLikeThis
{
    NSString *youAndString = @"";
    if(youLikeThis){
        youAndString = @" you &";
    }
    
    NSString *text = [NSString stringWithFormat:@"+%@ %i friends liked this",youAndString,numberOfPeople];
    
    self.label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].footnote, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
}








@end
