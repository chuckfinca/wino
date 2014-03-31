//
//  TimelineSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimelineSCDTVC.h"
#import <CoreData/CoreData.h>
#import "ColorSchemer.h"
#import "DocumentHandler.h"
#import "TastingRecordCell.h"
#import "TastingRecord.h"
#import "Review.h"
#import "User.h"
#import "DateStringFormatter.h"
#import "ReviewsTVController.h"

#define TASTING_RECORD_ENTITY @"TastingRecord"

#define TASTING_RECORD_CELL @"TastingRecordCell"

@interface TimelineSCDTVC ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) TastingRecordCell *tastingRecordSizingCell;

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

-(void)awakeFromNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"TastingRecordCell" bundle:nil] forCellReuseIdentifier:TASTING_RECORD_CELL];
    self.tableView.backgroundColor = [ColorSchemer sharedInstance].customDarkBackgroundColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - Getters & Setters

-(TastingRecordCell *)tastingRecordSizingCell
{
    if(!_tastingRecordSizingCell){
        _tastingRecordSizingCell = [[[NSBundle mainBundle] loadNibNamed:@"TastingRecordCell" owner:self options:nil] firstObject];
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
    
    if([self.fetchedResultsController.fetchedObjects count] == 0){
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
    
    for(Review *r in tastingRecord.reviews){
        NSLog(@"review = %@",r);
    }
    // NSLog(@"rating = %@",tastingRecord.review.rating);
    
    
    NSLog(@"\n\n\n");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableView){
        return [[self.fetchedResultsController sections] count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView){
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    } else {
        TastingRecord *tr = self.fetchedResultsController.fetchedObjects[tableView.tag];
        return [tr.reviews count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TastingRecordCell *trCell = (TastingRecordCell *)[tableView dequeueReusableCellWithIdentifier:TASTING_RECORD_CELL forIndexPath:indexPath];
    trCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TastingRecord *tastingRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [trCell setupWithTastingRecord:tastingRecord];
    
    return trCell;
}



#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TastingRecord *tastingRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.tastingRecordSizingCell setupWithTastingRecord:tastingRecord];
    return self.tastingRecordSizingCell.bounds.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ReviewsSegue" sender:cell];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    ReviewsTVController *reviewTVC = (ReviewsTVController *)segue.destinationViewController;
    
    [reviewTVC setupFromTastingRecord:(TastingRecord *)self.fetchedResultsController.fetchedObjects[indexPath.row]];
    
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
