//
//  InstructionsCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsCDTVC.h"

@interface InstructionsCDTVC ()

@end

@implementation InstructionsCDTVC

#pragma mark - Getters & setters

-(UITableViewCell *)instructionsCell
{
    if(!_instructionsCell){
        _instructionsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Instructions Cell"];
        _instructionsCell.backgroundColor = [UIColor redColor];
    }
    return _instructionsCell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.fetchedResultsController.fetchedObjects count] == 0){
        return 1;
    } else {
        return [[self.fetchedResultsController sections] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.fetchedResultsController.fetchedObjects count] == 0){
        return 1;
    } else {
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if([self.fetchedResultsController.fetchedObjects count] == 0){
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
    if([self.fetchedResultsController.fetchedObjects count] == 0){
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
    // Abstract
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([self.fetchedResultsController.fetchedObjects count] == 0){
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
    if([self.fetchedResultsController.fetchedObjects count] == 0){
        return nil;
    } else {
        return [self titleForHeaderInSection:section];
    }
}

-(NSString *)titleForHeaderInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.fetchedResultsController.fetchedObjects count] > 0){
        [self userDidSelectRowAtIndexPath:indexPath];
    }
}

-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Abstract
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                if(indexPath.row == 0){
                    [self.tableView reloadData];
                } else {
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
                
            case NSFetchedResultsChangeDelete:
                if(indexPath.row == 0){
                    [self.tableView reloadData];
                } else {
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


@end
