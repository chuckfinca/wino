//
//  TimelineSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Timeline_TRSICDTVC.h"
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

@interface Timeline_TRSICDTVC () <UIGestureRecognizerDelegate>

@property (nonatomic) CGPoint touchLocation;

@end

@implementation Timeline_TRSICDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Tasting Timeline";
    self.displayWineNameOnEachCell = YES;
}

#pragma mark - Setup

-(void)registerInstructionCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell_Timeline" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
}

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
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
        self.displayInstructionsCell = YES;
    } else {
        self.displayInstructionsCell = NO;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
