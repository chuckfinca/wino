//
//  InstructionsCell_Timeline.m
//  Corkie
//
//  Created by Charles Feinn on 5/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsCell_Timeline.h"
#import "VariableHeightTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@interface InstructionsCell_Timeline ()

@property (weak, nonatomic) IBOutlet UIImageView *instructionsImageView;
@property (weak, nonatomic) IBOutlet VariableHeightTV *instructionsVHTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToInstructionsVhtvConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsVhtvToBottomConstraint;
@end

@implementation InstructionsCell_Timeline

- (void)awakeFromNib
{
    // Initialization code
    
    NSString *instructions = @"Your timeline is where you keep track of all the wines you drink.\n\nTo add a Tasting Record to your timeline go to that wine's details page and click the 'Tried It' button.";
    self.instructionsVHTV.attributedText = [[NSAttributedString alloc] initWithString:instructions attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    
    self.instructionsImageView.image = [[UIImage imageNamed:@"instructions_timeline.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.instructionsImageView.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}


-(void)setViewHeight
{
    CGFloat height = 0;
    height += self.topToInstructionsVhtvConstraint.constant;
    height += [self.instructionsVHTV height];
    height += self.instructionsVhtvToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

@end
