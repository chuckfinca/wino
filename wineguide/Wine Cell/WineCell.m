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

@property (nonatomic) float defaultWineNameLabelToReviewsLabelHeightConstraint;
@property (nonatomic) float defaultTalkingHeadLabelXPosition;
@property (nonatomic) float defaultReviewsLabelXPosition;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewsLabelToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameLabelToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToTalkingHeadsLabelConstraint;

@end

@implementation WineCell

-(void)awakeFromNib
{
    self.defaultWineNameLabelToReviewsLabelHeightConstraint = self.wineNameLabelToReviewsLabelConstraint.constant;
    self.defaultTalkingHeadLabelXPosition = self.talkingHeadsLabel.frame.origin.x;
    self.defaultReviewsLabelXPosition = self.reviewsLabel.frame.origin.x;
}

#pragma mark - Getters & setters

-(NSMutableArray *)talkingHeadsArray
{
    if(!_talkingHeadsArray){
        _talkingHeadsArray = [[NSMutableArray alloc] init];
    }
    return _talkingHeadsArray;
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
    if(self.talkingHeadButtonOne){
        
        // Reset
        self.talkingHeadsArray = nil;
        self.leftToTalkingHeadsLabelConstraint.constant = self.defaultTalkingHeadLabelXPosition;
        self.talkingHeadButtonOne.hidden = NO;
        self.talkingHeadButtonTwo.hidden = NO;
        self.talkingHeadButtonThree.hidden = NO;
        self.talkingHeadsLabel.hidden = NO;
        
        NSInteger numberOfTalkingHeads = arc4random_uniform(5);
        
        // For testing
        if(self.numberOfTalkingHeads){
            numberOfTalkingHeads = self.numberOfTalkingHeads;
        }
        
        BOOL youLikeThis = [wine.user_favorite boolValue];
        
        if(numberOfTalkingHeads < 1){
            self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonOne.frame.origin.x;
            self.talkingHeadButtonOne.hidden = YES;
        } else {
            [self.talkingHeadsArray addObject:self.talkingHeadButtonOne];
        }
        
        if(numberOfTalkingHeads < 2){
            if(self.talkingHeadButtonTwo.frame.origin.x < self.leftToTalkingHeadsLabelConstraint.constant){
                self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonTwo.frame.origin.x;
            }
            self.talkingHeadButtonTwo.hidden = YES;
        } else {
            [self.talkingHeadsArray addObject:self.talkingHeadButtonTwo];
        }
        
        if(numberOfTalkingHeads < 3){
            if(self.talkingHeadButtonThree.frame.origin.x < self.leftToTalkingHeadsLabelConstraint.constant){
                self.leftToTalkingHeadsLabelConstraint.constant = self.talkingHeadButtonThree.frame.origin.x;
            }
            self.talkingHeadButtonThree.hidden = YES;
        } else {
            [self.talkingHeadsArray addObject:self.talkingHeadButtonThree];
        }
        
        if(numberOfTalkingHeads > 3 || youLikeThis){
            NSInteger additionalPeople = numberOfTalkingHeads - 3;
            [self.talkingHeadsLabel setupLabelWithNumberOfAdditionalPeople:additionalPeople andYou:youLikeThis];
            
        } else {
            self.talkingHeadsLabel.hidden = YES;
        }
        
        if(numberOfTalkingHeads == 0 && self.talkingHeadsLabel.hidden == YES){
            self.wineNameLabelToReviewsLabelConstraint.constant = 8;
        } else {
            self.wineNameLabelToReviewsLabelConstraint.constant = self.defaultWineNameLabelToReviewsLabelHeightConstraint;
        }
    }
}

-(void)setupRatingForWine:(Wine *)wine
{
    if(self.glassRatingImageViewArray){
        
        NSInteger numberOfRatings = arc4random_uniform(5);
        float rating = 0;
        
        if(numberOfRatings > 0){
            rating = arc4random_uniform(50);
            rating /= 10;
        }
        
        [RatingPreparer setupRating:rating inImageViewArray:self.glassRatingImageViewArray withWineColorString:wine.color];
        
        if(!rating || rating == 0){
            numberOfRatings = 0;
            self.leftToReviewsLabelConstraint.constant = self.wineNameLabel.frame.origin.x;
        } else {
            self.leftToReviewsLabelConstraint.constant = self.defaultReviewsLabelXPosition;
        }
        
        [self.reviewsLabel setupForNumberOfReviews:numberOfRatings];
        
        self.wineNameLabelToBottomConstraint = nil;
        
    } else {
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
    
    height += self.wineNameLabelToReviewsLabelConstraint.constant;
    
    if(self.reviewsLabel){
        height += self.reviewsLabel.bounds.size.height;
        height += self.reviewsLabelToBottomConstraint.constant;
    } else if(!self.glassRatingImageViewArray){
        height += self.wineNameLabelToBottomConstraint.constant;
    }
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}


- (IBAction)pushUserProfile:(UIButton *)sender
{
    NSLog(@"push profile for button %ld",(long)sender.tag);
}







@end

