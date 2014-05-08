//
//  InstructionsCell_RequestGPS.m
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsCell_RequestGPS.h"
#import "VariableHeightTV.h"
#import "RoundedRectButton.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@interface InstructionsCell_RequestGPS ()

@property (weak, nonatomic) IBOutlet VariableHeightTV *instructions_VHTV;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet RoundedRectButton *accessButton;
@property (weak, nonatomic) IBOutlet UIImageView *gpsImageView;

// Vertical constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToInstructionsVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsVhtvToAccessButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accessButtonToBottomConstraint;

@end

@implementation InstructionsCell_RequestGPS

-(void)awakeFromNib
{
    // Initialization code
    
    NSString *accessButtonText = @"Allow access to your location";
    NSAttributedString *accessButtonAttributedText = [[NSAttributedString alloc] initWithString:accessButtonText attributes:@{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].customWhite, NSFontAttributeName : [FontThemer sharedInstance].body}];
    [self.accessButton setAttributedTitle:accessButtonAttributedText forState:UIControlStateNormal];
    
    NSString *instructions = @"In order to find the restaurant you're at Corkie needs access to your location data.";
    self.instructions_VHTV.attributedText = [[NSAttributedString alloc] initWithString:instructions attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    self.gpsImageView.image = [[UIImage imageNamed:@"instructions_gps.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.gpsImageView.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    self.mapImageView.layer.masksToBounds = YES;
    self.mapImageView.layer.cornerRadius = 10;
    
    [self setViewHeight];
}

-(void)setViewHeight
{
    CGFloat height = 0;
    height += self.topToInstructionsVHTVConstraint.constant;
    height += [self.instructions_VHTV height];
    height += self.instructionsVhtvToAccessButtonConstraint.constant;
    height += self.accessButton.bounds.size.height;
    height += self.accessButtonToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

#pragma mark - Target action

- (IBAction)requestAccess:(id)sender
{
    NSLog(@"requestAccess...");
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
