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

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *vintageAndVarietals;
@property (weak, nonatomic) IBOutlet UILabel *numberOfReviews;
@property (weak, nonatomic) IBOutlet UILabel *tastingNotes;
@property (nonatomic, strong) Wine *wine;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *numFriendsLabel;

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

-(void)setupCell
{
    
}


-(void)setupCellForWine:(Wine *)wine
{
    [self setupCell];
    
    self.wine = wine;
    
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
    
    if(!self.abridged){
        
        int r = arc4random_uniform(50) + 1;
        self.numberOfReviews.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i reviews",r] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
        
        NSString *youAndString = @"";
        if([self.wine.favorite boolValue] == YES){
            youAndString = @" you &";
        }
        
        r = arc4random_uniform(10) + 1;
        NSMutableAttributedString *numFriendsAttributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@ %i friends liked this",youAndString,r] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
        
        if([self.wine.favorite boolValue] == YES){
            [numFriendsAttributedText addAttribute:NSForegroundColorAttributeName
                                             value:[ColorSchemer sharedInstance].textLink
                                             range:NSMakeRange(2, 3)];
            
            UIFontDescriptor *fontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];
            UIFontDescriptor *boldFontDescriptor = [fontDesciptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];

            [numFriendsAttributedText addAttribute:NSFontAttributeName
                                             value:[UIFont fontWithDescriptor:boldFontDescriptor size:0]
                                             range:NSMakeRange(2, 3)];
        }
        self.numFriendsLabel.attributedText = numFriendsAttributedText;
        
        NSString *tastingNotesString = @"";
        if(wine.tastingNotes){
            NSArray *tastingNotes = [wine.tastingNotes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
            for(TastingNote *tastingNote in tastingNotes){
                tastingNotesString = [tastingNotesString stringByAppendingString:[NSString stringWithFormat:@"%@, ",tastingNote.name]];
            }
            tastingNotesString = [tastingNotesString substringToIndex:[tastingNotesString length]-2];
        }
        self.tastingNotes.attributedText = [[NSAttributedString alloc] initWithString:tastingNotesString attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
        
    } else {
        [self.numberOfReviews removeFromSuperview];
        [self.tastingNotes removeFromSuperview];
        [self.star1 removeFromSuperview];
        [self.star2 removeFromSuperview];
        [self.star3 removeFromSuperview];
        [self.star4 removeFromSuperview];
        [self.star5 removeFromSuperview];
    }
    
}








@end
