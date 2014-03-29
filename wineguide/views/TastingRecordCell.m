//
//  TastingRecordCell.m
//  Corkie
//
//  Created by Charles Feinn on 3/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecordCell.h"
#import "WineNameVHTV.h"
#import "ReviewView.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@interface TastingRecordCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) WineNameVHTV *wineNameVHTV;

@end

@implementation TastingRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Getters & setters

-(UILabel *)dateLabel
{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

-(WineNameVHTV *)wineNameVHTV
{
    if(!_wineNameVHTV){
        _wineNameVHTV = [[WineNameVHTV alloc] init];
        _wineNameVHTV.backgroundColor = [UIColor orangeColor];
        [self addSubview:_wineNameVHTV];
    }
    return _wineNameVHTV;
}

-(ReviewView *)addReviewFromDictionary:(NSDictionary *)reviewDictionary
{
    ReviewView *review = [[[NSBundle mainBundle] loadNibNamed:@"Review" owner:self options:nil] firstObject];
    
    [review setupReviewWithUserName:[reviewDictionary objectForKey:@"userName"]
                          userImage:[reviewDictionary objectForKey:@"userImage"]
                         reviewText:[reviewDictionary objectForKey:@"reviewText"]
                          wineColor:[reviewDictionary objectForKey:@"wineColor"]
                          andRating:[[reviewDictionary objectForKey:@"rating"] integerValue]];
    return review;
    
}

-(void)setupWithDateString:(NSString *)dateString wine:(Wine *)wine restaurant:(Restaurant *)restaurant andReviewsArray:(NSArray *)reviewsArray
{
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:dateString attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption2, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    
    [self.wineNameVHTV setupTextViewWithWine:wine fromRestaurant:restaurant];
    
    for(NSDictionary *review in reviewsArray){
        [self addReviewFromDictionary:review];
    }
    
    [self setupVerticalConstraints];
}

-(void)setupVerticalConstraints
{
    NSMutableArray *newVerticalConstraints = [NSMutableArray array];
    
    UIView *firstView = nil;
    UIView *secondView = nil;
    
    [newVerticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[firstView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView)]];
    
    for(NSInteger i = 1; i < [self.subviews count]; i++){
        secondView = self.subviews[i];
        [newVerticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstView-10-[secondView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView, secondView)]];
        firstView = secondView;
    }
    
    [newVerticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView)]];
}

-(float)height
{
    float height = 0;
    height += 8;
    height += ([self.subviews count] - 1)*10;
    height += 12;
    
    for(UIView *v in self.subviews){
        height += v.frame.size.height;
    }
    return height;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}












@end
