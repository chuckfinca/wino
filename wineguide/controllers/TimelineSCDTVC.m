//
//  TimelineSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 2/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimelineSCDTVC.h"
#import <CoreData/CoreData.h>
#import "TastingRecord.h"
#import "ColorSchemer.h"
#import "DocumentHandler.h"
#import "TastingRecordTVCell.h"

#define TASTING_RECORD_ENTITY @"TastingRecord"

#define TASTING_RECORD_CELL @"TastingRecordCell"

@interface TimelineSCDTVC ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *tastingRecords;
@property (nonatomic, strong) TastingRecordTVCell *tastingRecordSizingCell;

@end

@implementation TimelineSCDTVC

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
    self.navigationItem.title = @"My Timeline";
    self.tableView.backgroundColor = [ColorSchemer sharedInstance].customDarkBackgroundColor;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TastingRecordTVCell" bundle:nil] forCellReuseIdentifier:TASTING_RECORD_CELL];
}


#pragma mark - Getters & Setters

-(TastingRecordTVCell *)tastingRecordSizingCell
{
    if(!_tastingRecordSizingCell){
        _tastingRecordSizingCell = [[[NSBundle mainBundle] loadNibNamed:@"TastingRecordTVCell" owner:self options:nil] firstObject];
    }
    return _tastingRecordSizingCell;
}

#pragma mark - Setup

-(void)refresh
{
    [self getManagedObjectContext];
    if (self.context){
        [self setupFetchedResultsController];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
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
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tastingDate"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES]];
    
    request.predicate = nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
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
    // NSLog(@"rating = %@",tastingRecord.review.rating);
    
    
    NSLog(@"\n\n\n");
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TastingRecordTVCell *cell = (TastingRecordTVCell *)[tableView dequeueReusableCellWithIdentifier:TASTING_RECORD_CELL forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TastingRecord *tastingRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupCellWithTastingRecord:tastingRecord];
    
    [cell setNeedsLayout];
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TastingRecord *tr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.tastingRecordSizingCell setupCellWithTastingRecord:tr];
    
    return self.tastingRecordSizingCell.bounds.size.height;
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
