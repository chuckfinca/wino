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

#define RATING_CELL @"RatingCell"
#define RATING_TEXT_CELL @"RatingTextCell"


@interface RatingsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL displayText;
@property (nonatomic) float rating;
@property (nonatomic, strong) UIColor *wineColor;
@property (nonatomic, strong) NSString *wineColorString;
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
    
    [self setupFlowlayout];
    
    self.numberOfReviews = arc4random_uniform(100);
    
    self.collectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

#pragma mark - Setup

-(void)setupFlowlayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 2;
    [self.collectionView setCollectionViewLayout:flowLayout];
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
    //self.rating = rating;
    
    self.rating = arc4random_uniform(6) + drand48();
    
    self.wineColorString = wineColorString;
    [self setWineColorFromString:wineColorString];
    self.displayText = displayText;
    
    [self.collectionView reloadData];
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
    return 6;
    
    NSInteger numberOfItemsInSection = 0;
    if(self.displayText){
        numberOfItemsInSection++;
    }
    if(self.numberOfReviews > 0){
        numberOfItemsInSection += 5;
    }
    return numberOfItemsInSection;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.numberOfReviews > 0){
        if(indexPath.row < 5){
            RatingCVCell *ratingCell = (RatingCVCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:RATING_CELL forIndexPath:indexPath];
            
            if(indexPath.row + 1 > self.rating){
                if(self.rating - indexPath.row >= 0.5){
                    [ratingCell.imageView setImage:self.half];
                } else {
                    [ratingCell.imageView setImage:self.empty];
                }
            } else {
                [ratingCell.imageView setImage:self.full];
            }
            ratingCell.imageView.tintColor = self.wineColor;
            
            return ratingCell;
        }
    }
    
    RatingTextCVCell *ratingTextCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:RATING_TEXT_CELL forIndexPath:indexPath];
    [ratingTextCell setupForNumberOfReviews:self.numberOfReviews];
    
    return ratingTextCell;
}


#pragma mark - UICollectionViewFlowDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.numberOfReviews > 0 && indexPath.row < 5){
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
