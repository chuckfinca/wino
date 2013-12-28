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


@interface WineCell ()

@property (nonatomic, strong) Wine *wine;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *vintageAndVarietals;

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

#pragma mark - Getters & Setters

-(ReviewersAndRatingsVC *)reviewersAndRatingsVC
{
    if(!_reviewersAndRatingsVC){
        _reviewersAndRatingsVC = [[ReviewersAndRatingsVC alloc] initWithNibName:@"RatingsAndReviews" bundle:nil];
    }
    return _reviewersAndRatingsVC;
}

-(void)setupCellForWine:(Wine *)wine
{
    self.wine = wine;
    
    [self setupText];
    
    if(!self.abridged){
        [self.ratingsAndReviewsView addSubview:self.reviewersAndRatingsVC.view];
        [self.reviewersAndRatingsVC setupForWine:wine];
    } else {
        [self.ratingsAndReviewsView removeFromSuperview];
    }
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupText
{
    Wine *wine = self.wine;
    
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
