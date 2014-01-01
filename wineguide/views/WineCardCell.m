//
//  WineCardCell.m
//  Gimme
//
//  Created by Charles Feinn on 12/11/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineCardCell.h"
#import "ColorSchemer.h"
#import "Varietal.h"
#import "TastingNote.h"

#define CORNER_RADIUS 2

@interface WineCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *vintageAndVarietals;
@property (nonatomic, strong) Wine *wine;
@property (weak, nonatomic) IBOutlet UILabel *userRatingCVLabel;
@property (weak, nonatomic) IBOutlet UIButton *inDepthReviewButton;
@property (weak, nonatomic) IBOutlet UIView *userRatingContainerView;

@end

@implementation WineCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Getters & Setters

-(UserRatingCVController *)userRatingsController
{
    if(!_userRatingsController) {
        _userRatingsController = [[UserRatingCVController alloc] initWithCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
        _userRatingsController.wine = self.wine;
    }
    return _userRatingsController;
}


#pragma mark - Setup

-(void)setupCardWithWine:(Wine *)wine
{
    self.wine = wine;
    
    self.userRatingsController.wine = self.wine;
    self.userRatingsController.collectionView.frame = self.userRatingContainerView.bounds;
    [self.userRatingContainerView addSubview:self.userRatingsController.collectionView];
    
    [self setupCard];
    
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

-(void)setupCard
{
    CALayer *layer = self.layer;
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setShadowColor:[ColorSchemer sharedInstance].shadowColor.CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.5];
    
    self.backgroundColor = [ColorSchemer sharedInstance].customWhite;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (IBAction)presentReviewViewController:(UIButton *)sender
{
    
}

@end
