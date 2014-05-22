//
//  TimelineSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Timeline_TRSICDTVC.h"
#import "GetMe.h"
#import "TastingRecord2.h"
#import "Review2.h"

#define TASTING_RECORD_ENTITY @"TastingRecord2"

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
    NSNumber *meIdentifier = [GetMe sharedInstance].me.identifier;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TASTING_RECORD_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tasting_date"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(reviews,$r, $r.user.identifier == %@).@count != 0",meIdentifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    if([self.fetchedResultsController.fetchedObjects count] == 0){
        [self setupInstructionsCell];
    } else {
        if(self.displayInstructionsCell == YES){
            [self removeInstructionsCell];
        }
    }
}

-(void)setupInstructionsCell
{
    self.suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    self.displayInstructionsCell = YES;
}

-(void)removeInstructionsCell
{
    self.displayInstructionsCell = NO;
    self.instructionsCell = nil;
    self.suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
    [self setupAndSearchFetchedResultsControllerWithText:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
