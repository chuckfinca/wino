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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToInstructionsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsLabelToBottomConstraint;
@end

@implementation InstructionsCell_TriedIt

- (void)awakeFromNib
{
    // Initialization code
    [self.arrowImageView setImage:[[UIImage imageNamed:@"instructions_arrow_up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.arrowImageView.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    self.instructionsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Check this wine into your Timeline to remember who you drank this with and what you thought." attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToInstructionsLabelConstraint.constant;
    
    NSLog(@"self.instructionsLabel.bounds.size.width = %f",self.instructionsLabel.bounds.size.width);
    
    CGSize instructionsLabelSize = [self.instructionsLabel sizeThatFits:CGSizeMake(self.instructionsLabel.bounds.size.width, FLT_MAX)];
    height += instructionsLabelSize.height + 1;
    height += self.instructionsLabelToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}
@end
