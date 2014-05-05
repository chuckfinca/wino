//
//  TalkingHeadsVC.m
//  Corkie
//
//  Created by Charles Feinn on 5/2/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TalkingHeadsVC.h"
#import "TalkingHeadsCVCell.h"
#import "TalkingHeadsTextCVCell.h"
#import "ColorSchemer.h"
#import "FacebookProfileImageGetter.h"

#define TALKING_HEAD_CELL @"Talking Head Cell"
#define TALKING_HEAD_TEXT_CELL @"Talking Heads Text Cell"

@interface TalkingHeadsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger numberOfTalkingHeads;
@property (nonatomic, strong) TalkingHeads *talkingHeads;
@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;
@property (nonatomic, strong) UIColor *customBackgroundColor;
@property (nonatomic) BOOL userLikesThis;

@end

@implementation TalkingHeadsVC

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"TalkingHeadsCVCell" bundle:nil] forCellWithReuseIdentifier:TALKING_HEAD_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TalkingHeadsTextCVCell" bundle:nil] forCellWithReuseIdentifier:TALKING_HEAD_TEXT_CELL];
    
    [self setupFlowlayout];
}

#pragma mark - Getters & setters

-(FacebookProfileImageGetter *)facebookProfileImageGetter
{
    if(!_facebookProfileImageGetter){
        _facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    }
    return _facebookProfileImageGetter;
}

#pragma mark - Setup

-(void)setupFlowlayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 2;
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(void)setupWithNumberOfTalkingHeads:(NSInteger)numberOfTalkingHeads andYou:(BOOL)userLikesThis withBackgroundColor:(UIColor *)backgroundColor
{
    self.numberOfTalkingHeads = numberOfTalkingHeads;
    self.userLikesThis = userLikesThis;
    
    self.collectionView.backgroundColor = backgroundColor;
    [self.collectionView reloadData];
}

-(void)setupWithTalkingHeads:(TalkingHeads *)talkingHeads andYou:(BOOL)userLikesThis withBackgroundColor:(UIColor *)backgroundColor
{
    self.talkingHeads = talkingHeads;
    self.userLikesThis = userLikesThis;
    
    self.collectionView.backgroundColor = backgroundColor;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.numberOfTalkingHeads > 0){
        return self.numberOfTalkingHeads+1;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if(indexPath.row == self.numberOfTalkingHeads || indexPath.row == 3){
        
        TalkingHeadsTextCVCell *textCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TALKING_HEAD_TEXT_CELL forIndexPath:indexPath];
        [textCell setupForNumberOfPeople:arc4random_uniform(10) includingYou:self.userLikesThis];
        
        cell = textCell;
        
    } else {
        TalkingHeadsCVCell *talkingHeadCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TALKING_HEAD_CELL forIndexPath:indexPath];
        
        __weak UICollectionView *weakCollectionView = self.collectionView;
        [self.facebookProfileImageGetter setProfilePicForUser:nil inImageView:talkingHeadCell.imageView completion:^(BOOL success) {
            if(success){
                [weakCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }];
        
        cell = talkingHeadCell;
    }
    cell.backgroundColor = self.collectionView.backgroundColor;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@",indexPath);
}


#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.numberOfTalkingHeads || indexPath.row == 3){
        return CGSizeMake(160, 40);
        
    } else {
        return CGSizeMake(40, 40);
    }
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
