//
//  InstructionsCDTVC.h
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "CoreDataTableViewController.h"

#define INSTRUCTIONS_CELL_REUSE_IDENTIFIER @"Instructions Cell"

@interface Instructions_CDTVC : CoreDataTableViewController

@property (nonatomic, strong) UITableViewCell *instructionsCell; // Abstract - register below:
-(void)registerInstructionCellNib; // Abstract - REQUIRED to display the instructions cell

@property (nonatomic) BOOL displayInstructionsCell; // use to show/hide instructions cell when appropriate, default is YES

// Replacement UITableView Delegate and Datasource methods

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath; // Abstract
-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath; // Abstract
-(UIView *)viewForHeaderInSection:(NSInteger)section; // Abstract
-(CGFloat)heightForHeaderInSection:(NSInteger)section; // Abstract
-(NSString *)titleForHeaderInSection:(NSInteger)section; // Abstract
-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath; // Abstract


-(void)refreshFetchedResultsController; // For use by the Searchable_ICDTVC

@end
