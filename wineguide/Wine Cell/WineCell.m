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
#import "FacebookProfileImageGetter.h"
#import "TalkingHeadsLabel.h"

@interface WineCell ()

@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *talkingHeadsImageViewArray;
@property (weak, nonatomic) IBOutlet TalkingHeadsLabel *talkingHeadsLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *glassRatingImageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToTalkingHeadsImageViewArrayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsImageViewArrayToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewsLabelToBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToReviewsLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToBottomConstraint;


@property (nonatomic, strong) UIImage *empty;
@property (nonatomic, strong) UIImage *half;
@property (nonatomic, strong) UIImage *full;
@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;

@end

@implementation WineCell

- (void)awakeFromNib
{
    // Initialization code
}

#pragma mark - Getters & setters

-(UIImage *)empty
{
    if(!_empty){
        _empty = [[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _empty;
}

-(UIImage *)half
{
    if(!_half){
        _half = [[UIImage imageNamed:@"glass_half.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _half;
}

-(UIImage *)full
{
    if(!_full){
        _full = [[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _full;
}

-(FacebookProfileImageGetter *)facebookProfileImageGetter
{
    if(!_facebookProfileImageGetter){
        _facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    }
    return _facebookProfileImageGetter;
}

#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    // Wine object will come with a rating history, which will be used to determine the ratings, and a talking heads object, which will be used to determine the talking heads.
    
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:nil];
    [self setupRatingForWine:wine];
    
    [self setupTalkingHeadsForWine:wine];
    
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
        NSLog(@"talkingHeadsImageViewArray DOES NOT exist");
        self.wineNameVHTVToTalkingHeadsImageViewArrayConstraint = nil;
        self.talkingHeadsImageViewArrayToReviewsLabelConstraint = nil;
    }
}

-(void)setupRatingForWine:(Wine *)wine
{
    NSInteger numberOfRatings = 0;
    
    if(self.glassRatingImageViewArray){
        NSLog(@"setting up glassRatingImageViewArray");
        UIColor *wineColor = [self setWineColorFromString:wine.color];
        
        float rating = (arc4random_uniform(50)+1)/10;
        
        for(UIImageView *glass in self.glassRatingImageViewArray){
            if(glass.tag + 1 > rating){
                if(rating - glass.tag >= 0.5){
                    [glass setImage:self.half];
                } else {
                    [glass setImage:self.empty];
                }
            } else {
                [glass setImage:self.full];
            }
            glass.tintColor = wineColor;
        }
        
        numberOfRatings = arc4random_uniform(120);
        
        [self setupForNumberOfReviews:numberOfRatings];
        
        self.wineNameVHTVToBottomConstraint = nil;
        
    } else {
        self.wineNameVHTVToTalkingHeadsImageViewArrayConstraint = nil;
        self.talkingHeadsImageViewArrayToReviewsLabelConstraint = nil;
        self.reviewsLabelToBottomConstraint = nil;
        self.wineNameVHTVToReviewsLabelConstraint = nil;
    }
}

-(UIColor *)setWineColorFromString:(NSString *)wineColorString
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
    return wineColor;
}

-(void)setupForNumberOfReviews:(NSInteger)numberOfReviews
{
    NSAttributedString *attributedString;
    NSString *text;
    if(numberOfReviews > 0){
        text = [NSString stringWithFormat:@"%ld review",(long)numberOfReviews];
        if(numberOfReviews > 1){
            text = [text stringByAppendingString:@"s"];
        }
        attributedString = [[NSAttributedString alloc] initWithString:text attributes:[FontThemer sharedInstance].secondaryCaption1TextAttributes];
    } else {
        text = @"Be the first to try it!";
        attributedString = [[NSAttributedString alloc] initWithString:text attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
    }
    
    self.reviewsLabel.attributedText = attributedString;
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

