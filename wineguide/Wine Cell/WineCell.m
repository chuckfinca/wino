//
//  WineCell.m
//  Corkie
//
//  Created by Charles Feinn on 5/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineCell.h"
#import "ColorSchemer.h"
#import "TalkingHeadsLabel.h"
#import "RatingPreparer.h"
#import "ReviewsLabel.h"
#import "WineNameLabel.h"

@interface WineCell ()

@property (weak, nonatomic) IBOutlet WineNameLabel *wineNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *talkingHeadButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *talkingHeadButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *talkingHeadButtonThree;
@property (weak, nonatomic) IBOutlet TalkingHeadsLabel *talkingHeadsLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *glassRatingImageViewArray;
@property (weak, nonatomic) IBOutlet ReviewsLabel *reviewsLabel;

@property (nonatomic) float talkingHeadButtonHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToTalkingHeadsButtonArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsButtonArrayToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewsLabelToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToTalkingHeadsLabelConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadButtonOneHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadButtonTwoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadButtonThreeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsLabelHeightConstraint;

@end

@implementation WineCell

-(void)awakeFromNib
{
    self.talkingHeadButtonHeight = self.talkingHeadButtonOne.bounds.size.height;
    NSLog(@"self.talkingHeadButtonHeight = %f",self.talkingHeadButtonHeight);
}

#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    // Wine object will come with a rating history, which will be used to determine the ratings, and a talking heads object, which will be used to determine the talking heads.
    
    [self.wineNameLabel setupForWine:wine fromRestaurant:nil];
    
    [self setupTalkingHeadsForWine:wine];
    [self setupRatingForWine:wine];
    
    [self setupBackgroundColorForWine:wine];
    
    [self setViewHeight];
    
    self.wineNameLabel.backgroundColor = [UIColor greenColor];
    self.reviewsLabel.backgroundColor = [UIColor orangeColor];
}

-(void)setupTalkingHeadsForWine:(Wine *)wine
{
    self.talkingHeadsArray = nil;
    
    if(self.talkingHeadButtonOne){
        NSInteger numberOfTalkingHeads = 0;//arc4random_uniform(5)+1;
        BOOL youLikeThis = [wine.user_favorite boolValue];
        
        if(numberOfTalkingHeads < 1){
            self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonOne.frame.origin.x;
            self.talkingHeadButtonOneHeightConstraint.constant = 0;
        } else {
            self.talkingHeadButtonOneHeightConstraint.constant = self.talkingHeadButtonHeight;
            [self.talkingHeadsArray addObject:self.talkingHeadButtonOne];
        }
        
        if(numberOfTalkingHeads < 2){
            if(self.talkingHeadButtonTwo.frame.origin.x < self.leftToTalkingHeadsLabelConstraint.constant){
                self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonTwo.frame.origin.x;
            }
            self.talkingHeadButtonTwoHeightConstraint.constant = 0;
        } else {
            self.talkingHeadButtonTwoHeightConstraint.constant = self.talkingHeadButtonHeight;
            [self.talkingHeadsArray addObject:self.talkingHeadButtonTwo];
        }
        
        if(numberOfTalkingHeads < 3){
            if(self.talkingHeadButtonThree.frame.origin.x < self.leftToTalkingHeadsLabelConstraint.constant){
                self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonThree.frame.origin.x;
            }
            self.talkingHeadButtonThreeHeightConstraint.constant = 0;
        } else {
            self.talkingHeadButtonThreeHeightConstraint.constant = self.talkingHeadButtonHeight;
            [self.talkingHeadsArray addObject:self.talkingHeadButtonThree];
        }
        
        if(numberOfTalkingHeads > 3 || youLikeThis){
            NSInteger additionalPeople = numberOfTalkingHeads - 3 > 0 ? numberOfTalkingHeads - 3 : 0;
            [self.talkingHeadsLabel setupLabelWithNumberOfAdditionalPeople:additionalPeople andYou:youLikeThis];
            self.talkingHeadsLabelHeightConstraint.constant = self.talkingHeadButtonHeight;
            
        } else {
            self.talkingHeadsLabelHeightConstraint.constant = 0;
        }
        
        self.wineNameLabelToReviewsLabelConstraint = nil;
    } else {
        self.wineNameLabelToTalkingHeadsButtonArrayConstraint = nil;
        self.talkingHeadsButtonArrayToReviewsLabelConstraint = nil;
    }

    
    }

-(void)setupRatingForWine:(Wine *)wine
{
    if(self.glassRatingImageViewArray){
        
        NSInteger numberOfRatings = arc4random_uniform(5);
        
        float rating = arc4random_uniform(50);
        rating /= 10;
        rating = 0;
        NSLog(@"rating = %f",rating);
        
        [RatingPreparer setupRating:rating inImageViewArray:self.glassRatingImageViewArray withWineColorString:wine.color];
        
        if(!rating || rating == 0){
            numberOfRatings = 0;
            self.leftToReviewsLabelConstraint.constant = self.wineNameLabel.frame.origin.x;
        }
        
        [self.reviewsLabel setupForNumberOfReviews:numberOfRatings];
        
        self.wineNameLabelToBottomConstraint = nil;
        
    } else {
        self.wineNameLabelToTalkingHeadsButtonArrayConstraint = nil;
        self.talkingHeadsButtonArrayToReviewsLabelConstraint = nil;
        self.reviewsLabelToBottomConstraint = nil;
        self.wineNameLabelToReviewsLabelConstraint = nil;
    }
}

-(void)setupBackgroundColorForWine:(Wine *)wine
{
    UIColor *backgroundColor;
    if([wine.user_favorite boolValue] == YES){
        backgroundColor = [ColorSchemer sharedInstance].baseColorLight;
    } else {
        backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    }
    self.backgroundColor = backgroundColor;
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToWineNameLabelConstraint.constant;
    
    CGSize wineNameLabelSize = [self.wineNameLabel sizeThatFits:CGSizeMake(self.wineNameLabel.bounds.size.width, FLT_MAX)];
    height += wineNameLabelSize.height;
    
    if(self.talkingHeadButtonOne){
        height += self.wineNameLabelToTalkingHeadsButtonArrayConstraint.constant;
        height += self.talkingHeadsLabelHeightConstraint.constant;
        height += self.talkingHeadsButtonArrayToReviewsLabelConstraint.constant;
        
    } else {
        height += self.wineNameLabelToReviewsLabelConstraint.constant;
    }
    
    if(self.reviewsLabel){
        height += self.reviewsLabel.bounds.size.height;
        height += self.reviewsLabelToBottomConstraint.constant;
    }
    
    if(!self.glassRatingImageViewArray && !self.reviewsLabel){
        height += self.wineNameLabelToBottomConstraint.constant;
    }
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}


- (IBAction)pushUserProfile:(UIButton *)sender
{
    NSLog(@"push profile for button %ld",(long)sender.tag);
}







@end

