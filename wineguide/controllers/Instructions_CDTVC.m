//
//  InstructionsCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Instructions_CDTVC.h"

#define DEFAULT_SECTION_HEADER_HEIGHT 0

@implementation Instructions_CDTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self registerInstructionCellNib];
    self.instructionsCell = [self.tableView dequeueReusableCellWithIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
    self.displayInstructionsCell = YES;
    
    // allows the tableview to load faster
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Getters & setters

-(UITableViewCell *)instructionsCell
{
    if(!_instructionsCell){
        _instructionsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
        _instructionsCell.backgroundColor = [UIColor redColor];
    }
    return _instructionsCell;
}

-(void)setDisplayInstructionsCell:(BOOL)displayInstructionsCell
{
    BOOL reloadTableView = NO;
    if(_displayInstructionsCell != displayInstructionsCell){
        reloadTableView = YES;
    }
    
    _displayInstructionsCell = displayInstructionsCell;
    
    if(displayInstructionsCell == YES){
        self.suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        self.suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
    }
    
    if(reloadTableView){
        [self refreshFetchedResultsController];
    }
}

#pragma mark - Setup

-(void)registerInstructionCellNib
{
    // Abstract
}

-(void)refreshFetchedResultsController
{
    // Abstract
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.displayInstructionsCell){
        return 1;
    } else {
        return [[self.fetchedResultsController sections] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.displayInstructionsCell){
        return 1;
    } else {
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(self.displayInstructionsCell){
        return self.instructionsCell;
    } else {
        cell = [self customTableViewCellForIndexPath:indexPath];
    }
    return cell;
}

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell; // Abstract
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.displayInstructionsCell){
        return [self heightForInstructionsCell];
    } else {
        return [self heightForCellAtIndexPath:indexPath];
    }
}

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    // Abstract
    return 80;
}

-(CGFloat)heightForInstructionsCell
{
    return self.instructionsCell.bounds.size.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.displayInstructionsCell){
        return nil;
    } else {
        return [self viewForHeaderInSection:section];
    }
}

-(UIView *)viewForHeaderInSection:(NSInteger)section
{
    // Abstract
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.displayInstructionsCell){
        return nil;
    } else {
        return [self titleForHeaderInSection:section];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.displayInstructionsCell){
        return DEFAULT_SECTION_HEADER_HEIGHT;
    } else {
        return [self heightForHeaderInSection:section];
    }
}

-(CGFloat)heightForHeaderInSection:(NSInteger)section
{
    // Abstract
    return DEFAULT_SECTION_HEADER_HEIGHT;
}

-(NSString *)titleForHeaderInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.displayInstructionsCell){
        [self userDidSelectRowAtIndexPath:indexPath];
    }
}

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Abstract
}









@end
