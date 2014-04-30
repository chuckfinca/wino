//
//  WineRatingAndReviewQuickviewVC.m
//  Corkie
//
//  Created by Charles Feinn on 4/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "WineRatingAndReviewQuickViewVC.h"
#import "Rating.h"
#import "RatingPreparer.h"

@interface WineRatingAndReviewQuickViewVC ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingImageViewArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *userImageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *usersLikedThisLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfReviewersLabel;

@property (nonatomic, strong) Wine *wine;

@end

@implementation WineRatingAndReviewQuickViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [RatingPreparer setupRating:[self.wine.rating.averageRating floatValue] inImageViewArray:self.ratingImageViewArray withWineColorString:self.wine.color];
    self.numberOfReviewersLabel.text = [NSString stringWithFormat:@"%@ reviews",self.wine.rating.totalRatings];
    NSLog(@"%@",self.numberOfReviewersLabel.text);NSLog(@"-%@",self.usersLikedThisLabel.text);
}

-(void)setupForWine:(Wine *)wine
{
    self.wine = wine;
}


- (IBAction)pushUserProfile:(UIButton *)sender
{
    NSLog(@"button tag = %ld",(long)sender.tag);
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}















@end
