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
@property (nonatomic, strong) User2 *user;

@end

@implementation Timeline_TRSICDTVC

-(id)initWithUser:(User2 *)user
{
    self = [super init];
    
    if(self){
        _user = user;
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Tasting Timeline",user.name_first];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Tasting Timeline";
    self.displayWineNameOnEachCell = YES;
    
    [self setupInstructionCellWithImage:[[UIImage imageNamed:@"instructions_timeline.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                   text:@"Your timeline is where you keep track of all the wines you drink.\n\nTo add a Tasting Record to your timeline go to that wine's details page and click the 'Tried It' button."
                           andExtraView:nil];
}

#pragma mark - Getters & setters

-(User2 *)user
{
    if(!_user){
        _user = [GetMe sharedInstance].me;
        self.navigationItem.title = @"My Tasting Timeline";
    }
    return _user;
}

#pragma mark - Setup

-(void)refreshFetchedResultsController
{
    NSNumber *userIdentifier = self.user.identifier;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TASTING_RECORD_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tasting_date"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                              ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(reviews,$r, $r.user.identifier == %@).@count != 0",userIdentifier];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    NSLog(@"count = %lu",(unsigned long)[self.fetchedResultsController.fetchedObjects count]);
    if([self.fetchedResultsController.fetchedObjects count] > 0){
        self.displayInstructionsCell = NO;
    }
}





@end
