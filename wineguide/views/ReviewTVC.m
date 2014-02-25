//
//  ReviewTVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ReviewTVC.h"
#import "ColorSchemer.h"

@interface ReviewTVC ()

@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *glass1;
@property (weak, nonatomic) IBOutlet UIImageView *glass2;
@property (weak, nonatomic) IBOutlet UIImageView *glass3;
@property (weak, nonatomic) IBOutlet UIImageView *glass4;
@property (weak, nonatomic) IBOutlet UIImageView *glass5;
@property (nonatomic, strong) NSArray *glasses;


// Vertical constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToReviewerNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewerNameToReviewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewToBottomConstraint;




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

#pragma mark - Getters & Setters

-(NSArray *)glasses
{
    if(!_glasses){
        _glasses = @[self.glass1, self.glass2, self.glass3, self.glass4, self.glass5];
    }
    return _glasses;
}


-(void)setupReviewForWineColor:(NSString *)wineColor
{
    self.reviewTextView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident...";
    
    
    // the view should just take the review object from the view controller and display it accordingly
    self.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setWineColorFromString:wineColor];
    
    UIImage *profileImage = [self randomAvatarGenerator];
    profileImage = [profileImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.userImageButton setImage:profileImage forState:UIControlStateNormal];
    self.userNameButton.tintColor = [ColorSchemer sharedInstance].textSecondary;
    self.followUserButton.tintColor = [ColorSchemer sharedInstance].clickable;
    [self randomRatingGenerator];
    
    
    [self setViewHeight];
}

-(void)setViewHeight
{
    // scrolling appears to need to be disabled inorder for constraints to be setup correctly. Seems to be a bug.
    self.reviewTextView.scrollEnabled = NO;
    
    CGFloat height = 0;
    
    height += self.userNameButton.bounds.size.height;
    height += self.reviewTextView.bounds.size.height;
    height += self.topToReviewerNameConstraint.constant;
    height += self.reviewerNameToReviewConstraint.constant;
    height += self.reviewToBottomConstraint.constant;
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

-(void)setWineColorFromString:(NSString *)wineColorString
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
    for(UIImageView *iv in self.glasses){
        iv.tintColor = wineColor;
    }
}

-(UIImage *)randomAvatarGenerator
{
    UIImage *image;
    
    int number = arc4random_uniform(4);
    switch (number) {
        case 0:
            image = [UIImage imageNamed:@"user_alan.png"];
            [self.userNameButton setTitle:@"Alan K." forState:UIControlStateNormal];
            break;
        case 1:
            image = [UIImage imageNamed:@"user_derek.png"];
            [self.userNameButton setTitle:@"Derek P." forState:UIControlStateNormal];
            break;
        case 2:
            image = [UIImage imageNamed:@"user_lisa.png"];
            [self.userNameButton setTitle:@"Lisa G." forState:UIControlStateNormal];
            break;
        case 3:
            image = [UIImage imageNamed:@"user_arturo.png"];
            [self.userNameButton setTitle:@"Arturo H." forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    return image;
}

-(void)randomRatingGenerator
{
    float rating = arc4random_uniform(5);
    rating = rating/2+2;
    
    for(UIImageView *iv in self.glasses){
        if([self.glasses indexOfObject:iv] > rating){
            [iv setImage:[[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else if ([self.glasses indexOfObject:iv]+1 > rating){
            [iv setImage:[[UIImage imageNamed:@"glass_half.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        } else {
            [iv setImage:[[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    }
}

@end
