//
//  WineCell.m
//  Gimme
//
//  Created by Charles Feinn on 12/3/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineCell.h"
#import "ColorSchemer.h"
#import "Wine.h"
#import "Varietal.h"
#import "TastingNote.h"
#import "WineNameVHTV.h"
#import "Rating.h"
#import "RatingsVC.h"
#import "TalkingHeadsVC.h"


@interface WineCell ()

@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (weak, nonatomic) IBOutlet UIView *ratingsContainerView;
@property (weak, nonatomic) IBOutlet UIView *talkingHeadsContainerView;

@property (nonatomic, strong) RatingsVC *ratingsVC;
@property (nonatomic, strong) TalkingHeadsVC *talkingHeadsVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToWineNameVhtvConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVhtvToTalkingHeadsContainerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsContainerViewToRatingsCvConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingsContainerViewToBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkingHeadsHeightConstraint;

@end
@implementation WineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Getters & setters

-(RatingsVC *)ratingsVC
{
    if(!_ratingsVC){
        _ratingsVC = [[RatingsVC alloc] initWithNibName:@"RatingsVC" bundle:nil];
        [self.ratingsContainerView addSubview:_ratingsVC.view];
    }
    return _ratingsVC;
}

-(TalkingHeadsVC *)talkingHeadsVC
{
    if(!_talkingHeadsVC){
        _talkingHeadsVC = [[TalkingHeadsVC alloc] initWithNibName:@"TalkingHeadsVC" bundle:nil];
        [self.talkingHeadsContainerView addSubview:_talkingHeadsVC.view];
    }
    return _talkingHeadsVC;
}


#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    [self setupCellForWine:wine numberOfTalkingHeads:2];
}

-(void)setupCellForWine:(Wine *)wine numberOfTalkingHeads:(NSInteger)numberOfTalkingHeads
{
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:nil];
    
    if(!self.abridged){
        [self.ratingsVC setupForRating:[wine.rating.averageRating floatValue] andWineColor:wine.color displayText:YES];
        [self setupTalkingHeadsVcWithNumberOfTalkingHeads:numberOfTalkingHeads];
        
    } else {
        [self.ratingsContainerView removeFromSuperview];
        [self.talkingHeadsContainerView removeFromSuperview];
    }
    
    [self setViewHeight];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupTalkingHeadsVcWithNumberOfTalkingHeads:(NSInteger)numberOfTalkingHeads
{
    if(numberOfTalkingHeads == 0){
        self.talkingHeadsContainerView.bounds = CGRectMake(0, 0, self.talkingHeadsVC.view.bounds.size.width, 0);
        self.talkingHeadsHeightConstraint.constant = 0;
    } else {
        self.talkingHeadsContainerView.bounds = CGRectMake(0, 0, self.talkingHeadsVC.view.bounds.size.width, 40);
        self.talkingHeadsHeightConstraint.constant = 40;
    }
    [self.talkingHeadsVC setupWithNumberOfTalkingHeads:numberOfTalkingHeads];
}

-(void)setViewHeight
{
    CGFloat height = 0;
    
    height += self.topToWineNameVhtvConstraint.constant;
    height += [self.wineNameVHTV height];
    height += self.wineNameVhtvToTalkingHeadsContainerViewConstraint.constant;
    height += self.talkingHeadsContainerView.bounds.size.height;
    height += self.talkingHeadsContainerViewToRatingsCvConstraint.constant;
    height += self.ratingsContainerView.bounds.size.height;
    height += self.ratingsContainerViewToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}







@end
