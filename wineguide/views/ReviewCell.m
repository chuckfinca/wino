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
#import "RatingPreparer.h"
#import "User2.h"
#import "FacebookProfileImageGetter.h"

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

-(void)setupWithReview:(Review2 *)review forWineColorCode:(NSNumber *)wineColorCode
{
    if(review.claimed){
        if(review.review_text){
            self.reviewTV.attributedText = [[NSAttributedString alloc] initWithString:review.review_text attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
        } else {
            self.reviewTV.attributedText = nil;
        }
        
        [RatingPreparer setupRating:[review.rating floatValue] inImageViewArray:self.ratingGlassArray withWineColor:wineColorCode];
        
        self.reviewButton.hidden = YES;
    } else {
        for(UIView *iv in self.ratingGlassArray){
            iv.hidden = YES;
        }
        self.reviewButton.hidden = NO;
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"REVIEW" attributes:[FontThemer sharedInstance].linkBodyTextAttributes];
        [self.reviewButton setAttributedTitle:attributedText forState:UIControlStateNormal];
        self.reviewTV.attributedText = nil;
    }
    // the view should just take the review object from the view controller and display it accordingly
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    
    FacebookProfileImageGetter *fpig = [[FacebookProfileImageGetter alloc] init];
    [fpig setProfilePicForUser:review.user inButton:self.userImageButton completion:^(BOOL success) {
        NSLog(@"successfully set user %@ profile image",review.user.identifier);
    }];
    
    [self.userNameButton setTitle:review.user.name_display forState:UIControlStateNormal];
    
    self.userNameButton.tintColor = [ColorSchemer sharedInstance].textSecondary;
    
    [self setViewHeight];
}



-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToUserImageConstraint.constant;
    height += self.userImageButton.bounds.size.height;
    height += self.userImageToReviewTextConstraint.constant;
    height += [self.reviewTV height];
    height += self.reviewTextToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}
#pragma mark - Target action

- (IBAction)sendToUserProfile:(id)sender
{
    [self.delegate pushUserProfileVcForReviewerNumber:self.tag];
}

- (IBAction)sendToUserReviewVC:(id)sender
{
    [self.delegate pushUserReviewVcForReviewerNumber:self.tag];
}




@end
