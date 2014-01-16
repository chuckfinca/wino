//
//  ReviewersAndRatingsVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ReviewersAndRatingsVC.h"
#import "ColorSchemer.h"
#import "CollectionViewWithIndex.h"
#import "ReviewersCVC.h"
#import "RatingsCVC.h"

#define RATINGS_COLLECTION_VIEW_CELL @"RatingsCollectionViewCell"
#define REVIEWS_COLLECTION_VIEW_CELL @"ReviewersCollectionViewCell"

@interface ReviewersAndRatingsVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reviewersLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;
@property (nonatomic, strong) NSMutableDictionary *tEMPORARYratings;
@property (nonatomic, strong) UIColor *wineGlassColor;

@end

@implementation ReviewersAndRatingsVC

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    [self.ratingsCollectionView registerNib:[UINib nibWithNibName:@"RatingsCVC" bundle:nil] forCellWithReuseIdentifier:RATINGS_COLLECTION_VIEW_CELL];
    self.ratingsCollectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.ratingsCollectionView.tag = RatingsCollectionView;
    
    [self.reviewersCollectionView registerNib:[UINib nibWithNibName:@"ReviewerCVC" bundle:nil] forCellWithReuseIdentifier:REVIEWS_COLLECTION_VIEW_CELL];
    self.reviewersCollectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.reviewersCollectionView.tag = ReviewersCollectionView;
}

-(void)setupForWine:(Wine *)wine
{
    [self reset];
    [self setupRatingsLabel];
    [self setupReviewersLabel];
    [self setColorForWine:wine];
    [self setupRatingsCollectionView];
    [self setupReviewsCollectionView];
}

-(void)setColorForWine:(Wine *)wine
{
    if([wine.color isEqualToString:@"red"]){
        self.wineGlassColor = [ColorSchemer sharedInstance].redWine;
    } else if([wine.color isEqualToString:@"rose"]){
        self.wineGlassColor = [ColorSchemer sharedInstance].roseWine;
    } else if([wine.color isEqualToString:@"white"]){
        self.wineGlassColor = [ColorSchemer sharedInstance].whiteWine;
    } else {
        NSLog(@"wine.color != red/rose/white");
    }
}

-(void)setupRatingsLabel
{
    NSString *reviewsText = @"11 reviews";
    NSAttributedString *reviewsAS = [[NSAttributedString alloc] initWithString:reviewsText attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary}];
    self.ratingsLabel.attributedText = reviewsAS;
}

-(void)setupRatingsCollectionView
{
    self.ratingsCollectionView.delegate = self;
    self.ratingsCollectionView.dataSource = self;
}

-(void)setupReviewsCollectionView
{
    self.reviewersCollectionView.delegate = self;
    self.reviewersCollectionView.dataSource = self;
}

-(void)setupReviewersLabel
{
    NSString *youAndString = @"";
    if(self.favorite){
        youAndString = @" you &";
    }
    
    int r = arc4random_uniform(10) + 1;
    NSMutableAttributedString *numFriendsAttributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@ %i friends liked this",youAndString,r] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
    
    if(self.favorite){
        [numFriendsAttributedText addAttribute:NSForegroundColorAttributeName
                                         value:[ColorSchemer sharedInstance].textLink
                                         range:NSMakeRange(2, 3)];
        
        UIFontDescriptor *fontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];
        UIFontDescriptor *boldFontDescriptor = [fontDesciptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        
        [numFriendsAttributedText addAttribute:NSFontAttributeName
                                         value:[UIFont fontWithDescriptor:boldFontDescriptor size:0]
                                         range:NSMakeRange(2, 3)];
    }
    self.reviewersLabel.attributedText = numFriendsAttributedText;
}

-(void)reset
{
    self.reviewersCollectionView.delegate = nil;
    self.reviewersCollectionView.dataSource = nil;
    self.ratingsCollectionView.delegate = nil;
    self.ratingsCollectionView.dataSource = nil;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItemsInSection = 0;
    
    if([collectionView isKindOfClass:[CollectionViewWithIndex class]]){
        CollectionViewWithIndex *collectionViewWithIndex = (CollectionViewWithIndex *)collectionView;
        
        if(collectionViewWithIndex.tag == RatingsCollectionView){
            numberOfItemsInSection = 6;
            
        } else if (collectionViewWithIndex.tag == ReviewersCollectionView){
            
            // the number below needs to be replaced with the number of friend reviews (up to 3 or 4) once we have users set up
            numberOfItemsInSection = 3;
            
            
        } else {
            NSLog(@"unknown collection view with tag = %i is asking for numberOfItemsInSection",collectionViewWithIndex.tag);
        }
    } else {
        NSLog(@"collection view asking for numberOfItemsInSection is not of class CollectionViewWithIndex");
    }
    
    return numberOfItemsInSection;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if(collectionView.tag == RatingsCollectionView){
        
        RatingsCVC *ratingsCell = (RatingsCVC *)[collectionView dequeueReusableCellWithReuseIdentifier:RATINGS_COLLECTION_VIEW_CELL forIndexPath:indexPath];
        [ratingsCell resetCell];
        
        CollectionViewWithIndex *cvwi = (CollectionViewWithIndex *)collectionView;
        float rating = [self ratingForIndexPath:cvwi.collectionViewIndexPath];
        
        ratingsCell.glassImageView.tintColor = self.wineGlassColor;
        
        
        [ratingsCell setupImageViewForGlassNumber:indexPath.row andRating:rating];
        
        cell = ratingsCell;
        
    } else if (collectionView.tag == ReviewersCollectionView){
        ReviewersCVC *reviewerCell = (ReviewersCVC *)[collectionView dequeueReusableCellWithReuseIdentifier:REVIEWS_COLLECTION_VIEW_CELL forIndexPath:indexPath];
        if(!reviewerCell.userAvatarButton.imageView.image){
            [reviewerCell.userAvatarButton setImage:[self randomAvatarGenerator] forState:UIControlStateNormal];
            reviewerCell.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
        }
        
        cell = reviewerCell;
    }
    
    return cell;
}

-(NSMutableDictionary *)tEMPORARYratings
{
    if(!_tEMPORARYratings) _tEMPORARYratings = [[NSMutableDictionary alloc] init];
    return _tEMPORARYratings;
}


-(float)ratingForIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath) {
        return 4.5;
    } else {
        float rating = [[self.tEMPORARYratings objectForKey:indexPath] floatValue];
        if(!rating){
            rating = arc4random_uniform(9) + 2;
            rating = rating/2;
            [self.tEMPORARYratings setObject:@(rating) forKey:indexPath];
        }
        return rating;
    }
}


-(UIImage *)randomAvatarGenerator
{
    UIImage *image;
    
    int number = arc4random_uniform(4);
    switch (number) {
        case 0:
            image = [UIImage imageNamed:@"user_alan.png"];
            break;
        case 1:
            image = [UIImage imageNamed:@"user_derek.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"user_lisa.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"user_arturo.png"];
            break;
            
        default:
            break;
    }
    
    return image;
}

#pragma mark - UICollectionViewDelegate







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
