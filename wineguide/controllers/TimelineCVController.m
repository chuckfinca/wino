//
//  TimelineCVC.m
//  Corkie
//
//  Created by Charles Feinn on 12/19/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "TimelineCVController.h"
#import <CoreData/CoreData.h>
#import "DocumentHandler.h"
#import "Wine.h"
#import "UserRatingCVC.h"
#import "ColorSchemer.h"
#import "TastingRecord.h"
#import "TastingRecordCVCell.h"
#import "Review.h"
#import "InstructionsVC.h"

#define TASTING_RECORD_CELL @"TastingRecordCVCell"
#define TASTING_RECORD_ENTITY @"TastingRecord"
#define USER_RATING_CELL @"UserRatingCell"

@interface TimelineCVController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *tastingRecords;
@property (nonatomic, strong) TastingRecordCVCell *sizingCell;

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
    [self.collectionView registerNib:[UINib nibWithNibName:TASTING_RECORD_CELL bundle:nil] forCellWithReuseIdentifier:TASTING_RECORD_CELL];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.navigationItem.title = @"My Timeline";
    self.collectionView.backgroundColor = [ColorSchemer sharedInstance].customDarkBackgroundColor;
    
    [self setupSizingCell];
    
    [self refresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupFetchedResultsController];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tastingRecords = nil;
    [self.collectionView reloadData];
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

-(void)setupSizingCell
{
    UINib *sizingCellNib = [UINib nibWithNibName:TASTING_RECORD_CELL bundle:nil];
    [self.collectionView registerNib:sizingCellNib forCellWithReuseIdentifier:TASTING_RECORD_CELL];
    
    // get a cell as template for sizing
    self.sizingCell = [[sizingCellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

-(void)setupFetchedResultsController
{
    //NSLog(@"Timeline setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TASTING_RECORD_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tastingDate"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES]];
    
    request.predicate = nil;
    
    NSError *error;
    self.tastingRecords = [self.context executeFetchRequest:request error:&error];
    
    NSLog(@"%@",self.tastingRecords);
    
    if([self.tastingRecords count] == 0){
        /*
        InstructionsVC *instructions = [[InstructionsVC alloc] init];
        instructions.view.frame = self.collectionView.frame;
        [self.view addSubview:instructions.view];
         */
    }
}

-(void)logDetailsOfTastingRecord:(TastingRecord *)tastingRecord
{
    NSLog(@"----------------------------------------");
    NSLog(@"identifier = %@",tastingRecord.identifier);
    NSLog(@"added date = %@",tastingRecord.addedDate);
    NSLog(@"tasting Date = %@",tastingRecord.tastingDate);
    NSLog(@"lastLocalUpdate = %@",tastingRecord.lastLocalUpdate);
    NSLog(@"lastServerUpdate = %@",tastingRecord.lastServerUpdate);
    NSLog(@"deletedEntity = %@",tastingRecord.deletedEntity);
    NSLog(@"review = %@",tastingRecord.review);
    NSLog(@"rating = %@",tastingRecord.review.rating);
    
    
    NSLog(@"\n\n\n");
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
    TastingRecordCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TASTING_RECORD_CELL forIndexPath:indexPath];
    
    TastingRecord *tastingRecord = [self.tastingRecords objectAtIndex:indexPath.row];
    [cell setupCellWithTastingRecord:tastingRecord];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

 -(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
 {
     NSLog(@"aaa");
     TastingRecordCVCell *cell = (TastingRecordCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
     
     for(UserRatingCVC *userRatingCell in cell.userRatingsController.collectionView.visibleCells){
 
         CGPoint touchLocationInWineCardCell = [collectionView.panGestureRecognizer locationInView:cell.userRatingsController.collectionView];
 
         if(CGRectContainsPoint(userRatingCell.frame, touchLocationInWineCardCell)){
             NSLog(@"bbb");
             [cell.userRatingsController collectionView:cell.userRatingsController.collectionView didSelectItemAtIndexPath:[cell.userRatingsController.collectionView indexPathForCell:userRatingCell]];
         }
     }
 }




#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TastingRecord *tastingRecord = [self.tastingRecords objectAtIndex:indexPath.row];
    [self.sizingCell setupCellWithTastingRecord:tastingRecord];
    
    return CGSizeMake(self.sizingCell.bounds.size.width-20, [self.sizingCell cellHeight]);
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

