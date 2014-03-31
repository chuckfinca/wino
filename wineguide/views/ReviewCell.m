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

@interface ReviewCell ()

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingGlassArray;
@property (weak, nonatomic) IBOutlet VariableHeightTV *reviewTV;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;

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


#pragma mark - Setup

-(void)setupClaimed:(BOOL)claimed reviewWithUserName:(NSString *)userName userImage:(UIImage *)userImage reviewText:(NSString *)reviewText wineColor:(NSString *)wineColor andRating:(NSNumber *)rating
{
    if(claimed){
        if(reviewText){
            self.reviewTV.attributedText = [[NSAttributedString alloc] initWithString:reviewText attributes:@{NSFontAttributeName : [FontThemer sharedInstance].body, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
        } else {
            self.reviewTV.attributedText = nil;
            self.reviewTV.frame = CGRectMake(self.reviewTV.frame.origin.x, self.reviewTV.frame.origin.y, self.reviewTV.frame.size.width, 1);
        }
        
        [self setWineColorFromString:wineColor];
        [self setupRating:[rating integerValue]];
        
        self.reviewButton.hidden = YES;
    } else {
        for(UIView *iv in self.ratingGlassArray){
            iv.hidden = YES;
        }
        self.reviewButton.hidden = NO;
        [self.reviewButton setTitle:@"REVIEW" forState:UIControlStateNormal];
    }
    
    
    
    // the view should just take the review object from the view controller and display it accordingly
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    userImage = [userImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.userImageButton setImage:userImage forState:UIControlStateNormal];
    
    [self.userNameButton setTitle:userName forState:UIControlStateNormal];
    self.userNameButton.tintColor = [ColorSchemer sharedInstance].textSecondary;
    self.userNameButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
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
        [self addSubview:iv];
    }
}

@end
