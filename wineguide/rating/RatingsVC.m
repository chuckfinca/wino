//
//  DisplayedRatingVC.m
//  Corkie
//
//  Created by Charles Feinn on 5/1/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingsVC.h"
#import "ColorSchemer.h"
#import "RatingCVCell.h"
#import "RatingTextCVCell.h"
#import "FontThemer.h"

#define RATING_CELL @"RatingCell"
#define RATING_TEXT_CELL @"RatingTextCell"


@interface RatingsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL displayText;
@property (nonatomic) BOOL displayRating;
@property (nonatomic) float rating;
@property (nonatomic, strong) UIColor *wineColor;
@property (nonatomic) NSInteger numberOfReviews;

@property (nonatomic, strong) UIImage *empty;
@property (nonatomic, strong) UIImage *half;
@property (nonatomic, strong) UIImage *full;
@property (nonatomic, strong) UILabel *text;

@end

@implementation RatingsVC

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"RatingCVCell" bundle:nil] forCellWithReuseIdentifier:RATING_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RatingTextCVCell" bundle:nil] forCellWithReuseIdentifier:RATING_TEXT_CELL];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 2;
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

#pragma mark - Getters & setters

-(UIImage *)empty
{
    if(!_empty){
        _empty = [[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _empty;
}

-(UIImage *)half
{
    if(!_half){
        _half = [[UIImage imageNamed:@"glass_half.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _half;
}

-(UIImage *)full
{
    if(!_full){
        _full = [[UIImage imageNamed:@"glass_full.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _full;
}

#pragma mark - Setup

-(void)setupForRating:(float)rating andWineColor:(NSString *)wineColorString displayText:(BOOL)displayText
{
    if(rating){
        self.rating = rating;
        self.displayRating = YES;
    } else {
        self.displayRating = NO;
    }
    
    [self setWineColorFromString:wineColorString];
    self.displayText = displayText;
}

-(void)setWineColorFromString:(NSString *)wineColorString
{
    if([wineColorString isEqualToString:@"red"]){
        self.wineColor = [ColorSchemer sharedInstance].redWine;
    } else if([wineColorString isEqualToString:@"rose"]){
        self.wineColor = [ColorSchemer sharedInstance].roseWine;
    } else if([wineColorString isEqualToString:@"white"]){
        self.wineColor = [ColorSchemer sharedInstance].whiteWine;
    } else {
        NSLog(@"wine.color != red/rose/white");
    }
}

#pragma mark - UICollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItemsInSection = 0;
    if(self.displayText){
        numberOfItemsInSection++;
    }
    if(self.displayRating){
        numberOfItemsInSection += 5;
    }
    return numberOfItemsInSection;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.displayRating){
        if(indexPath.row < 5){
            RatingCVCell *ratingCell = (RatingCVCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:RATING_CELL forIndexPath:indexPath];
            
            if(indexPath.row + 1 > self.rating){
                [ratingCell.imageView setImage:self.empty];
            } else if(indexPath.row + 1 <= self.rating) {
                [ratingCell.imageView setImage:self.full];
            } else {
                [ratingCell.imageView setImage:self.half];
            }
            ratingCell.imageView.tintColor = self.wineColor;
            
            return ratingCell;
        }
    }
    
    RatingTextCVCell *ratingTextCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:RATING_TEXT_CELL forIndexPath:indexPath];
    
    NSString *text;
    if(self.displayRating){
        text = [NSString stringWithFormat:@"%ld reviews",(long)self.numberOfReviews];
    } else {
        text = @" Be the first to try it!";
    }
    
    ratingTextCell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].footnote, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    
    return ratingTextCell;
}


#pragma mark - UICollectionViewFlowDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.displayRating && indexPath.row < 5){
        return CGSizeMake(15, 20);
    }
    
    return CGSizeMake(160, 20);
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
