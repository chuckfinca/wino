//
//  RestaurantGroupCell.m
//  Gimme
//
//  Created by Charles Feinn on 12/13/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantGroupCell.h"
#import "ColorSchemer.h"


@interface RestaurantGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *isVisibleImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@end
@implementation RestaurantGroupCell

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

-(void)setupCellAtIndexPath:(NSIndexPath *)indexPath forGroup:(Group *)group
{
    self.groupNameLabel.attributedText = [[NSAttributedString alloc] initWithString:[group.name capitalizedString] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    
    NSLog(@"aaa");
    if(indexPath.row < 4){
        NSLog(@"bbb");
        self.isVisibleImageView.hidden = NO;
    } else {
        NSLog(@"ccc");
        self.isVisibleImageView.hidden = YES;
    }
    
}

@end
