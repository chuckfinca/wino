//
//  ReviewView.m
//  Corkie
//
//  Created by Charles Feinn on 3/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewView.h"
#import "VariableHeightTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@interface ReviewView ()

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingGlassArray;
@property (weak, nonatomic) IBOutlet VariableHeightTV *reviewTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToUserImageButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageButtonToReviewTextConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTextToBottomConstraint;

@end

@implementation ReviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Setup

-(void)setupReviewWithUserName:(NSString *)userName userImage:(UIImage *)userImage reviewText:(NSString *)reviewText wineColor:(NSString *)wineColor andRating:(NSInteger)rating
{
    self.reviewTV.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident...";
    
    
    // the view should just take the review object from the view controller and display it accordingly
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self setWineColorFromString:wineColor];
    
    userImage = [userImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.userImageButton setImage:userImage forState:UIControlStateNormal];
    
    [self.userNameButton setTitle:userName forState:UIControlStateNormal];
    self.userNameButton.tintColor = [ColorSchemer sharedInstance].textSecondary;
    
    [self setupRating:rating];
    
    [self setViewHeight];
}

-(void)setViewHeight
{
    // scrolling appears to need to be disabled inorder for constraints to be setup correctly. Seems to be a bug.
    //self.reviewTV.scrollEnabled = NO;
    
    CGFloat height = 0;
    
    height += self.topToUserImageButtonConstraint.constant;
    height += self.userImageButton.bounds.size.height;
    height += self.userImageButtonToReviewTextConstraint.constant;
    height += [self.reviewTV height];
    height += self.reviewTextToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

-(void)setWineColorFromString:(NSString *)wineColorString
{
    UIColor *wineColor;
    if([wineColorString isEqualToString:@"red"]){
        wineColor = [ColorSchemer sharedInstance].redWine;
    } else if([wineColorString isEqualToString:@"rose"]){
        wineColor = [ColorSchemer sharedInstance].roseWine;
    } else if([wineColorString isEqualToString:@"white"]){
        wineColor = [ColorSchemer sharedInstance].whiteWine;
    } else {
        NSLog(@"wine.color != red/rose/white");
    }
    for(UIImageView *iv in self.ratingGlassArray){
        iv.tintColor = wineColor;
    }
}

-(void)setupRating:(NSInteger)rating
{
    for(UIImageView *iv in self.ratingGlassArray){
        if([self.ratingGlassArray indexOfObject:iv] > rating){
            [iv setImage:[[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if ([self.ratingGlassArray indexOfObject:iv]+1 > rating){
            [iv setImage:[[UIImage imageNamed:@"glass_half.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else {
            [iv setImage:[[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    }
}

@end
