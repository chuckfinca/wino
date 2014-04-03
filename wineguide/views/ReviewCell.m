//
//  ReviewView.m
//  Corkie
//
//  Created by Charles Feinn on 3/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewCell.h"
#import "VariableHeightTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "WineNameVHTV.h"
#import "RatingImageGenerator.h"

@interface ReviewCell ()

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingGlassArray;
@property (weak, nonatomic) IBOutlet VariableHeightTV *reviewTV;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;

@property (nonatomic, strong) UIImage *placeHolderImage;

// Vertical constraints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToUserImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageToReviewTextConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTextToBottomConstraint;

@end

@implementation ReviewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Getters & setters

-(UIImage *)placeHolderImage
{
    if(!_placeHolderImage){
        _placeHolderImage = [[UIImage imageNamed:@"user_default.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _placeHolderImage;
}

#pragma mark - Setup

-(void)setupClaimed:(BOOL)claimed reviewWithUserName:(NSString *)userName userImage:(UIImage *)userImage reviewText:(NSString *)reviewText wineColor:(NSString *)wineColor andRating:(NSNumber *)rating
{
    if(claimed){
        if(reviewText){
            self.reviewTV.attributedText = [[NSAttributedString alloc] initWithString:reviewText attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
        } else {
            self.reviewTV.attributedText = nil;
        }
        
        [RatingImageGenerator setupRating:[rating floatValue] inImageViewArray:self.ratingGlassArray];
        [self setWineColorFromString:wineColor];
        
        self.reviewButton.hidden = YES;
    } else {
        for(UIView *iv in self.ratingGlassArray){
            iv.hidden = YES;
        }
        self.reviewButton.hidden = NO;
        [self.reviewButton setTitle:@"REVIEW" forState:UIControlStateNormal];
        self.reviewTV.attributedText = nil;
    }
    
    
    
    // the view should just take the review object from the view controller and display it accordingly
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    
    if(userImage){
        userImage = [userImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        userImage = self.placeHolderImage;
    }
    [self.userImageButton setImage:userImage forState:UIControlStateNormal];
    
    [self.userNameButton setTitle:userName forState:UIControlStateNormal];
    self.userNameButton.tintColor = [ColorSchemer sharedInstance].textSecondary;
    
    [self setViewHeight];
}



-(void)setViewHeight
{
    CGFloat height = 0;
    
    NSLog(@"[self.reviewTV height] = %f",[self.reviewTV height]);
    
    height += self.topToUserImageConstraint.constant;
    height += self.userImageButton.bounds.size.height;
    height += self.userImageToReviewTextConstraint.constant;
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
        // NSLog(@"wine.color != red/rose/white");
    }
    for(UIImageView *iv in self.ratingGlassArray){
        iv.tintColor = wineColor;
    }
}

#pragma mark - Target action

- (IBAction)sendToUserProfile:(id)sender
{
    [self.delegate pushUserProfileVcForReviewerNumber:self.tag];
}





@end
