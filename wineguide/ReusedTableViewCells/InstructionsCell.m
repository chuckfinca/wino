//
//  InstructionsCell.m
//  Corkie
//
//  Created by Charles Feinn on 6/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsCell.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "UIView+BorderDrawer.h"

@interface InstructionsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *instructionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIView *extraView;

@property (nonatomic) BOOL displayInstructionsImageView;
@property (nonatomic) BOOL displayExtraView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToInstructionsImageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsImageViewToInstructionsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsLabelToExtraViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *extraViewToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *extraViewHeightConstraint;

@end

@implementation InstructionsCell

-(void)setupInstructionsCellWithImage:(UIImage *)image text:(NSString *)text andExtraView:(UIView *)extraView
{
    // Initialization code
    
    if(image){
        self.displayInstructionsImageView = YES;
        [self.instructionsImageView setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        self.instructionsImageView.tintColor = [ColorSchemer sharedInstance].baseColor;
    }
    
    if(text){
        self.instructionsLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    }
    
    if(extraView){
        self.displayExtraView = YES;
        extraView.frame = self.extraView.bounds;
        [self.extraView addSubview:extraView];
        self.extraView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    }
    [self setViewHeight];
    
    [self drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:YES bottom:YES left:NO andRight:NO];
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToInstructionsImageViewConstraint.constant;
    
    if(self.displayInstructionsImageView){
        height += self.instructionsImageViewHeightConstraint.constant;
        height += self.instructionsImageViewToInstructionsLabelConstraint.constant;
    } else {
        self.instructionsImageViewHeightConstraint.constant = 0;
        self.instructionsImageViewToInstructionsLabelConstraint.constant = 0;
    }
    
    CGSize instructionsLabelSize = [self.instructionsLabel sizeThatFits:CGSizeMake(self.instructionsLabel.bounds.size.width, FLT_MAX)];
    height += instructionsLabelSize.height + 1;
    
    if(self.displayExtraView){
        height += self.instructionsLabelToExtraViewConstraint.constant;
        height += self.extraView.bounds.size.height;
    } else {
        self.instructionsLabelToExtraViewConstraint.constant = 0;
        self.extraViewHeightConstraint.constant = 0;
    }
    
    height += self.extraViewToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

@end
