//
//  InstructionsCell_TriedIt.m
//  Corkie
//
//  Created by Charles Feinn on 5/23/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsCell_TriedIt.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@interface InstructionsCell_TriedIt ()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@end

@implementation InstructionsCell_TriedIt

- (void)awakeFromNib
{
    // Initialization code
    [self.arrowImageView setImage:[[UIImage imageNamed:@"instructions_arrow_up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.arrowImageView.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    self.instructionsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Click 'Tried It' above to check this wine into your Timeline. Be sure to tag your friends to see what they thought!" attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
