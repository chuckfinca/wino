//
//  TastingRecordSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 4/29/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TastingRecord_SICDTVC.h"
#import <CoreData/CoreData.h>
#import "ColorSchemer.h"
#import "TastingRecordCell.h"
#import "TastingRecord2.h"
#import "Review2.h"
#import "User2.h"
#import "DateStringFormatter.h"
#import "ReviewsTVController.h"
#import "UserProfileVC.h"

#define TASTING_RECORD_CELL @"TastingRecordCell"

@interface TastingRecord_SICDTVC () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) TastingRecordCell *tastingRecordSizingCell;
@property (nonatomic) CGPoint touchLocation;

@end

@implementation TastingRecord_SICDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addTapGestureRecognizer];
}
-(void)setup
{
    [self.tableView registerNib:[UINib nibWithNibName:@"TastingRecordCell" bundle:nil] forCellReuseIdentifier:TASTING_RECORD_CELL];
}

-(void)addTapGestureRecognizer
{
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gr.delegate = self;
    gr.numberOfTouchesRequired = 1;
    gr.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:gr];
}

#pragma mark - Getters & Setters

-(TastingRecordCell *)tastingRecordSizingCell
{
    if(!_tastingRecordSizingCell){
        _tastingRecordSizingCell = [[[NSBundle mainBundle] loadNibNamed:@"TastingRecordCell" owner:self options:nil] firstObject];
    }
    return _tastingRecordSizingCell;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    TastingRecordCell *trCell = (TastingRecordCell *)[self.tableView dequeueReusableCellWithIdentifier:TASTING_RECORD_CELL forIndexPath:indexPath];
    trCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TastingRecord2 *tastingRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [trCell setupWithTastingRecord:tastingRecord andDisplayWineName:self.displayWineNameOnEachCell];
    
    return trCell;
}



#pragma mark - UITableViewDelegate

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    TastingRecord2 *tastingRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.tastingRecordSizingCell setupWithTastingRecord:tastingRecord andDisplayWineName:self.displayWineNameOnEachCell];
    
    return self.tastingRecordSizingCell.bounds.size.height;
}


#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UITableView *tableView = (UITableView *)gestureRecognizer.view;
    self.touchLocation = [touch locationInView:tableView];
    
    if ([tableView indexPathForRowAtPoint:self.touchLocation]) {
        return YES;
    }
    
    return NO;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


-(void)handleTap:(UIGestureRecognizer *)tap
{
    if (UIGestureRecognizerStateEnded == tap.state) {
        UITableView *tableView = (UITableView *)tap.view;
        
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:self.touchLocation];
        
        TastingRecordCell *cell = (TastingRecordCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        CGPoint cellTouchLocation = [tap locationInView:cell];
        
        BOOL pushUserProfileVC = NO;
        
        User2 *user;
        
        for(UIButton *button in cell.userImageButtonArray){
            if(CGRectContainsPoint(button.frame, cellTouchLocation) && !button.hidden){
                
                TastingRecord2 *tastingRecord = self.fetchedResultsController.fetchedObjects[indexPath.row];
                NSArray *reviewsArray = [tastingRecord.reviews sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"reviewDate" ascending:YES]]];
                Review2 *review = reviewsArray[button.tag];
                user = review.user;
                pushUserProfileVC = YES;
                break;
            }
        }
        
        UIViewController *controller;
        
        if(pushUserProfileVC){
            controller = [[UserProfileVC alloc] initWithUser:user];
        } else {
            controller = [[ReviewsTVController alloc] init];
            [(ReviewsTVController *)controller setupFromTastingRecord:(TastingRecord2 *)self.fetchedResultsController.fetchedObjects[indexPath.row]];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end