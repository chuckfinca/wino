//
//  InstructionsCell_FacebookConnect.m
//  Corkie
//
//  Created by Charles Feinn on 5/6/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsCell_FacebookConnect.h"
#import "VariableHeightTV.h"
#import <FBLoginView.h>
#import "FontThemer.h"
#import "ColorSchemer.h"

@interface InstructionsCell_FacebookConnect ()

@property (weak, nonatomic) IBOutlet VariableHeightTV *instructionsVHTV;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToInstructionsVhtvConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsVhtvToLoginViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewToBottomConstraint;
@end

@implementation InstructionsCell_FacebookConnect

- (void)awakeFromNib
{
    // Initialization code
    NSString *text = @"Connect with Facebook to add friends to this tasting record.";
    self.instructionsVHTV.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    [self setViewHeight];
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToInstructionsVhtvConstraint.constant;
    height += [self.instructionsVHTV height];
    height += self.instructionsVhtvToLoginViewConstraint.constant;
    height += self.loginView.bounds.size.height;
    height += self.loginViewToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

@end
