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
#import "WineRatingAndReviewQuickViewVC.h"


@interface WineCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *vintageAndVarietals;
@property (weak, nonatomic) IBOutlet UIView *ratingsAndReviewsContainerView;

@property (nonatomic, strong) WineRatingAndReviewQuickViewVC *wineRatingAndReviewQuickViewVC;

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

-(WineRatingAndReviewQuickViewVC *)wineRatingAndReviewQuickViewVC
{
    if(!_wineRatingAndReviewQuickViewVC){
        _wineRatingAndReviewQuickViewVC = [[WineRatingAndReviewQuickViewVC alloc] initWithNibName:@"WineRatingAndReviewQuickViewVC" bundle:nil];
        [self.ratingsAndReviewsContainerView addSubview:_wineRatingAndReviewQuickViewVC.view];
    }
    return _wineRatingAndReviewQuickViewVC;
}



#pragma mark - Setup

-(void)setupCellForWine:(Wine *)wine
{
    [self setupTextForWine:wine];
    
    if(!self.abridged){
        [self.wineRatingAndReviewQuickViewVC setupForWine:wine];
    } else {
        [self.ratingsAndReviewsContainerView removeFromSuperview];
    }
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupTextForWine:(Wine *)wine
{
    if(wine.name){
        self.name.attributedText = [[NSAttributedString alloc] initWithString:[wine.name capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    }
    
    NSString *vintageAndVarietals = @"";
    if(wine.vintage){
        NSString *vintageString = [wine.vintage stringValue];
        vintageAndVarietals = [vintageAndVarietals stringByAppendingString:[NSString stringWithFormat:@"%@",[vintageString capitalizedString]]];
    }
    if(wine.varietals){
        NSString *varietalsString = @"";
        if(wine.vintage) {
            varietalsString = @" - ";
        }
        NSArray *varietals = [wine.varietals sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        for(Varietal *varietal in varietals){
            varietalsString = [varietalsString stringByAppendingString:[NSString stringWithFormat:@"%@, ",varietal.name]];
        }
        varietalsString = [varietalsString substringToIndex:[varietalsString length]-2];
        vintageAndVarietals = [vintageAndVarietals stringByAppendingString:[NSString stringWithFormat:@"%@",[varietalsString capitalizedString]]];
    }
    self.vintageAndVarietals.attributedText = [[NSAttributedString alloc] initWithString:vintageAndVarietals attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    
}








@end
