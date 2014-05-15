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
@property (weak, nonatomic) IBOutlet TalkingHeadsLabel *talkingHeadsLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *glassRatingImageViewArray;
@property (weak, nonatomic) IBOutlet ReviewsLabel *reviewsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToTalkingHeadsButtonArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsButtonArrayToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewsLabelToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToBottomConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *glassToReviewsLabelConstraint;

@end

@implementation WineCell

#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    // Wine object will come with a rating history, which will be used to determine the ratings, and a talking heads object, which will be used to determine the talking heads.
    
    [self.wineNameLabel setupForWine:wine fromRestaurant:nil];
    
    [self setupTalkingHeadsForWine:wine];
    [self setupRatingForWine:wine];
    
    [self setupBackgroundColorForWine:wine];
    
    [self setViewHeight];
}


-(void)setupTalkingHeadsForWine:(Wine *)wine
{
    if(self.talkingHeadsButtonArray){
        NSInteger numberOfTalkingHeads = arc4random_uniform(15) + 1;
        
        for(UIButton *talkingHeadButton in self.talkingHeadsButtonArray){
            [talkingHeadButton setImage:[[UIImage imageNamed:@"user_default.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            talkingHeadButton.tintColor = [ColorSchemer sharedInstance].baseColor;
            /*
             if(talkingHead.tag + 1 <= numberOfTalkingHeads){
             
             
             [self.facebookProfileImageGetter setProfilePicForUser:nil inImageView:talkingHead completion:^(BOOL success) {
             if(success){
             [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             }
             }];
             }
             */
        }
        
        NSInteger additionalPeople = numberOfTalkingHeads - 3 > 0 ? numberOfTalkingHeads - 3 : 0;
        [self.talkingHeadsLabel setupLabelWithNumberOfAdditionalPeople:additionalPeople andYou:[wine.user_favorite boolValue]];
        
        self.wineNameLabelToReviewsLabelConstraint = nil;
    } else {
        self.wineNameLabelToTalkingHeadsButtonArrayConstraint = nil;
        self.talkingHeadsButtonArrayToReviewsLabelConstraint = nil;
    }
}

-(void)setupRatingForWine:(Wine *)wine
{
    NSInteger numberOfRatings = arc4random_uniform(120)+1;
    
    if(self.glassRatingImageViewArray){
        
        float rating = (arc4random_uniform(50)+1)/10;
        
        [RatingPreparer setupRating:rating inImageViewArray:self.glassRatingImageViewArray withWineColorString:wine.color];
        
        if(!rating || rating == 0){
            numberOfRatings = 0;
            self.glassToReviewsLabelConstraint.constant = -83;
        } else {
            self.glassToReviewsLabelConstraint.constant = 8;
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
    
    NSLog(@"self.wineNameLabel.bounds.size.width = %f",self.wineNameLabel.bounds.size.width);
    CGSize wineNameLabelSize = [self.wineNameLabel sizeThatFits:CGSizeMake(260, FLT_MAX)];
    height += wineNameLabelSize.height;
    
    if(self.talkingHeadsButtonArray){
        height += self.wineNameLabelToTalkingHeadsButtonArrayConstraint.constant;
        UIButton *talkingHeadButton = [self.talkingHeadsButtonArray firstObject];
        height += talkingHeadButton.bounds.size.height;
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

