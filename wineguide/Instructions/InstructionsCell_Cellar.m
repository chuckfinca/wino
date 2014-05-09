//
//  InstructionsCell_Cellar.m
//  Corkie
//
//  Created by Charles Feinn on 5/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsCell_Cellar.h"
#import "VariableHeightTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@interface InstructionsCell_Cellar ()

@property (weak, nonatomic) IBOutlet UIImageView *instructionsImageView;
@property (weak, nonatomic) IBOutlet VariableHeightTV *instructionsVHTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToInstructionsVhtvConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsVhtvToBottomConstraint;
@end

@implementation InstructionsCell_Cellar

- (void)awakeFromNib
{
    // Initialization code
    
    NSString *instructions = @"Your cellar is where you keep track of all the wines you love.\n\nTo add a wine to your cellar go to that wine's details page and click the 'Cellar' button.";
    self.instructionsVHTV.attributedText = [[NSAttributedString alloc] initWithString:instructions attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    
    self.instructionsImageView.image = [[UIImage imageNamed:@"cellar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.instructionsImageView.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    [self setViewHeight];
}


-(void)setViewHeight
{
    CGFloat height = 0;
    height += self.topToInstructionsVhtvConstraint.constant;
    height += [self.instructionsVHTV height]*1.1;
    height += self.instructionsVhtvToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

@end
