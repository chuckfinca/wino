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

@property (nonatomic, strong) UITableViewCell *instructionsCell; // Abstract

-(void)registerInstructionCellNib; // Abstract - REQUIRED to display the instructions cell

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath; // Abstract
-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath; // Abstract
-(UIView *)viewForHeaderInSection:(NSInteger)section; // Abstract
-(CGFloat)heightForHeaderInSection:(NSInteger)section; // Abstract
-(NSString *)titleForHeaderInSection:(NSInteger)section; // Abstract
-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath; // Abstract


@end
