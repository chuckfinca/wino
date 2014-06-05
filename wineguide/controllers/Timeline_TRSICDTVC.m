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
    
    [self setupInstructionCellWithImage:[UIImage imageNamed:@"instructions_timeline.png"]
                                   text:@"Your timeline is where you keep track of all the wines you drink.\n\nTo add a Tasting Record to your timeline go to that wine's details page and click the 'Tried It' button."
                           andExtraView:nil];
}

#pragma mark - Setup

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
    if([self.fetchedResultsController.fetchedObjects count] > 0){
        self.displayInstructionsCell = NO;
    }
}





@end
