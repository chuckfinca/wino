//
//  WineCell.m
//  Corkie
//
//  Created by Charles Feinn on 5/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineCell.h"
#import "WineNameVHTV.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "TalkingHeadsLabel.h"
#import "RatingPreparer.h"
#import "ReviewsLabel.h"

@interface WineCell ()

@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet TalkingHeadsLabel *talkingHeadsLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *glassRatingImageViewArray;
@property (weak, nonatomic) IBOutlet ReviewsLabel *reviewsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToTalkingHeadsImageViewArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsImageViewArrayToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewsLabelToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToBottomConstraint;

@end

@implementation WineCell

#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    // Wine object will come with a rating history, which will be used to determine the ratings, and a talking heads object, which will be used to determine the talking heads.
    
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:nil];
    [self setupTalkingHeadsForWine:wine];
    [self setupRatingForWine:wine];
    
    [self setViewHeight];
}


-(void)setupTalkingHeadsForWine:(Wine *)wine
{
    if(self.talkingHeadsImageViewArray){
        NSLog(@"talkingHeadsImageViewArray exists");
        NSInteger numberOfTalkingHeads = arc4random_uniform(15) + 1;
        
        for(UIImageView *talkingHead in self.talkingHeadsImageViewArray){
            [talkingHead setImage:[UIImage imageNamed:@"user_default.png"]];
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
        
        self.wineNameVHTVToReviewsLabelConstraint = nil;
    } else {
        self.wineNameVHTVToTalkingHeadsImageViewArrayConstraint = nil;
        self.talkingHeadsImageViewArrayToReviewsLabelConstraint = nil;
    }
}

-(void)setupRatingForWine:(Wine *)wine
{
    NSInteger numberOfRatings = 0;
    
    if(self.glassRatingImageViewArray){
        float rating = (arc4random_uniform(50)+1)/10;
        [RatingPreparer setupRating:rating inImageViewArray:self.glassRatingImageViewArray withWineColorString:wine.color];
        
        numberOfRatings = arc4random_uniform(120);
        [self.reviewsLabel setupForNumberOfReviews:numberOfRatings];
        
        self.wineNameVHTVToBottomConstraint = nil;
        
    } else {
        self.wineNameVHTVToTalkingHeadsImageViewArrayConstraint = nil;
        self.talkingHeadsImageViewArrayToReviewsLabelConstraint = nil;
        self.reviewsLabelToBottomConstraint = nil;
        self.wineNameVHTVToReviewsLabelConstraint = nil;
    }
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToWineNameVHTVConstraint.constant;
    height += [self.wineNameVHTV height];
    
    if(self.glassRatingImageViewArray){
        height += self.wineNameVHTVToTalkingHeadsImageViewArrayConstraint.constant;
        UIImageView *talkingHeadImageView = [self.talkingHeadsImageViewArray firstObject];
        height += talkingHeadImageView.bounds.size.height;
        height += self.talkingHeadsImageViewArrayToReviewsLabelConstraint.constant;
    } else {
        height += self.wineNameVHTVToReviewsLabelConstraint.constant;
    }
    
    if(self.reviewsLabel){
        height += self.reviewsLabel.bounds.size.height;
        height += self.reviewsLabelToBottomConstraint.constant;
    }
    
    if(!self.glassRatingImageViewArray && !self.reviewsLabel){
        height += self.wineNameVHTVToBottomConstraint.constant;
    }
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}









@end

