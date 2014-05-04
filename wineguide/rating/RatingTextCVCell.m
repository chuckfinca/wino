//
//  RatingTextCVCell.m
//  Corkie
//
//  Created by Charles Feinn on 5/1/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingTextCVCell.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@interface RatingTextCVCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation RatingTextCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupForNumberOfReviews:(NSInteger)numberOfReviews
{
    NSString *text;
    if(numberOfReviews > 0){
        text = [NSString stringWithFormat:@"%ld reviews",(long)numberOfReviews];
    } else {
        text = @"Be the first to try it!";
    }
    
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption1, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
