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

#define TALKING_HEAD_CELL @"Talking Head Cell"
#define TALKING_HEAD_TEXT_CELL @"Talking Heads Text Cell"

@interface TalkingHeadsVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger numberOfTalkingHeads;

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
    
    self.collectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)setupWithNumberOfTalkingHeads:(NSInteger)numberOfTalkingHeads
{
    self.numberOfTalkingHeads = numberOfTalkingHeads;
}

#pragma mark - UICollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfTalkingHeads+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@",indexPath);
        NSLog(@"numberOfTalkingHeads = %ld",(long)self.numberOfTalkingHeads);
    if(indexPath.row == self.numberOfTalkingHeads || indexPath.row == 3){
        
        TalkingHeadsTextCVCell *textCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TALKING_HEAD_TEXT_CELL forIndexPath:indexPath];
        [textCell setupForNumberOfPeople:self.numberOfTalkingHeads includingYou:YES];
        
        return textCell;
        
    } else {
        TalkingHeadsCVCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TALKING_HEAD_CELL forIndexPath:indexPath];
        
        return cell;
    }
}


#pragma mark - UICollectionViewFlowDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.numberOfTalkingHeads || indexPath.row == 3){
        return CGSizeMake(130, 40);
        
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
