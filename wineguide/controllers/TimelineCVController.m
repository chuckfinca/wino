//
//  TimelineCVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/19/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TimelineCVController.h"
#import "WineCardCell.h"
#import <CoreData/CoreData.h>
#import "DocumentHandler.h"
#import "Wine.h"
#import "UserRatingCVC.h"
#import "ColorSchemer.h"
#import "UserRatingCVController.h"
#import "TastingRecord.h"

#define WINE_CARD_CELL @"WineCardCell"
#define TASTING_RECORD_ENTITY @"TastingRecord"
#define USER_RATING_CELL @"UserRatingCell"

@interface TimelineCVController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *tastingRecords;

@end

@implementation TimelineCVController

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
    [self.collectionView registerNib:[UINib nibWithNibName:WINE_CARD_CELL bundle:nil] forCellWithReuseIdentifier:WINE_CARD_CELL];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.title = @"Timeline";
    self.collectionView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView.collectionViewLayout invalidateLayout];
    //self.collectionView.contentOffset = CGPointMake(0,0);
}

#pragma mark - Setup

-(void)refresh
{
    [self getManagedObjectContext];
    if (self.context){
        [self setupFetchedResultsController];
    }
}

-(void)getManagedObjectContext
{
    if(!self.context && [DocumentHandler sharedDocumentHandler]){
        self.context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
    } else {
        [self listenForDocumentReadyNotification];
        NSLog(@"cannot get managed object context because either self.context exists (%@) or [DocumentHandler sharedDocumentHandler] does not exist (%@). Did start listening to DocumentReady notifications",self.context,[DocumentHandler sharedDocumentHandler]);
    }
}

-(void)setupFetchedResultsController
{
    //NSLog(@"Timeline setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TASTING_RECORD_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    request.predicate = nil;
    
    NSError *error;
    self.tastingRecords = [self.context executeFetchRequest:request error:&error];
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tastingRecords count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WineCardCell *wineCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:WINE_CARD_CELL forIndexPath:indexPath];
    
    TastingRecord *tr = [self.tastingRecords objectAtIndex:indexPath.row];
    [wineCardCell setupCardWithWine:tr.wine];
    
    return wineCardCell;
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WineCardCell *wineCardCell = (WineCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    for(UserRatingCVC *userRatingCell in wineCardCell.userRatingsController.collectionView.visibleCells){
        
        CGPoint touchLocationInWineCardCell = [collectionView.panGestureRecognizer locationInView:wineCardCell.userRatingsController.collectionView];
        
        if(CGRectContainsPoint(userRatingCell.frame, touchLocationInWineCardCell)){
            [wineCardCell.userRatingsController collectionView:wineCardCell.userRatingsController.collectionView didSelectItemAtIndexPath:[wineCardCell.userRatingsController.collectionView indexPathForCell:userRatingCell]];
        }
    }
}


#pragma mark - Listen for Notifications

-(void)listenForDocumentReadyNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"Document Ready"
                                               object:nil];
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

