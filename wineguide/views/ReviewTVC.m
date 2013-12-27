//
//  ReviewTVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ReviewTVC.h"

@interface ReviewTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *userActionCollectionView;
@end


@implementation ReviewTVC

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


-(void)setupReview
{
    // the view should just take the review object from the view controller and display it accordingly
    
    UIImage *profileImage = [UIImage imageNamed:@"user_derek.png"];
    [self.profilePhotoImageView setImage:profileImage];
}



@end
