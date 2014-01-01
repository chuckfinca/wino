//
//  UserRatingCVController.m
//  Corkie
//
//  Created by Charles Feinn on 12/31/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "UserRatingCVController.h"
#import "UserRatingCVC.h"
#import "ColorSchemer.h"

#define USER_RATING_CELL @"UserRatingCell"
#define REVIEW_CELL @"ReviewCell"
#define GLASS_SCALE_RATIO 0.75

@interface UserRatingCVController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation UserRatingCVController

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"UserRatingCVC" bundle:nil] forCellWithReuseIdentifier:USER_RATING_CELL];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:REVIEW_CELL];
    
    self.collectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 6;
    layout.minimumLineSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 5){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:REVIEW_CELL forIndexPath:indexPath];
        
        UIButton *reviewButton = [self setupReviewButtonWithRect:cell.bounds];
        [cell addSubview:reviewButton];
        
        return cell;
        
    } else {
        UserRatingCVC *urCell = [collectionView dequeueReusableCellWithReuseIdentifier:USER_RATING_CELL forIndexPath:indexPath];
        [urCell glassColorString:self.wine.color isEmpty:YES];
        
        return urCell;
    }
}

-(UIButton *)setupReviewButtonWithRect:(CGRect)rect
{
    UIButton *reviewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reviewButton.frame = rect;
    [reviewButton addTarget:self action:@selector(launchFullReviewVC) forControlEvents:UIControlEventTouchUpInside];
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"Full Review" attributes:@{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textLink, NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]}];
    
    [reviewButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    
    return reviewButton;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for(id cell in collectionView.visibleCells){
        if([cell isKindOfClass:[UserRatingCVC class]]){
            UserRatingCVC *glass = (UserRatingCVC *)cell;
            int rating = indexPath.row;
            if([collectionView indexPathForCell:glass].row <= rating){
                [glass glassColorString:self.wine.color isEmpty:NO];
            } else {
                [glass glassColorString:self.wine.color isEmpty:YES];
            }
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float y = 44*GLASS_SCALE_RATIO;
    
    if(indexPath.row == 5){
        return CGSizeMake(100, y);
    } else {
        return CGSizeMake(30*GLASS_SCALE_RATIO, y);
    }
}



#pragma mark - Target Action

-(void)launchFullReviewVC
{
    NSLog(@"launchFullReviewVC");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
