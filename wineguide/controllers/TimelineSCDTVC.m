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
#import "UserProfileVC.h"
#import "GetMe.h"

#define TASTING_RECORD_ENTITY @"TastingRecord"

@interface TimelineSCDTVC () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) CGPoint touchLocation;

@end

@implementation TimelineSCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Tasting Timeline";
    self.displayWineNameOnEachCell = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}


-(void)setupFetchedResultsController
{
    //NSLog(@"Timeline setupFetchedResultsController...");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TASTING_RECORD_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tastingDate"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY reviews.user.identifier = %@",[GetMe sharedInstance].me.identifier];
    
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
    
    // NSLog(@"%@",self.fetchedResultsController.fetchedObjects);
}

-(void)logFetchResultsForController:(NSFetchedResultsController *)frc
{
    NSLog(@"fetchedResultCount = %lu",(unsigned long)[frc.fetchedObjects count]);
    for(NSObject *fetchedResult in frc.fetchedObjects){
        NSLog(@"fetchedResult = %@",fetchedResult.description);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
