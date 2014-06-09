//
//  InstructionsCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 5/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Instructions_CDTVC.h"
#import "InstructionsCell.h"
#import "ColorSchemer.h"

#define DEFAULT_SECTION_HEADER_HEIGHT 0

@interface Instructions_CDTVC ()

@property (nonatomic, strong) UIImage *instructionsImage;
@property (nonatomic, strong) NSString *instructionsText;
@property (nonatomic, strong) UIView *instructionsExtraView;

@end

@implementation Instructions_CDTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
    self.displayInstructionsCell = YES;
    
    // allows the tableview to load faster
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = [ColorSchemer sharedInstance].lightGray;
    self.tableView.separatorColor = [ColorSchemer sharedInstance].gray;
    self.tableView.sectionIndexBackgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.tableView.sectionIndexColor = [ColorSchemer sharedInstance].baseColor;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - Getters & setters

-(void)setDisplayInstructionsCell:(BOOL)displayInstructionsCell
{
    BOOL reloadTableView = NO;
    if(_displayInstructionsCell && _displayInstructionsCell != displayInstructionsCell){
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

-(void)setupInstructionCellWithImage:(UIImage *)image text:(NSString *)text andExtraView:(UIView *)extraView
{
    self.instructionsImage = image;
    self.instructionsText = text;
    self.instructionsExtraView = extraView;
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
        
        InstructionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
        [cell setupInstructionsCellWithImage:self.instructionsImage text:self.instructionsText andExtraView:self.instructionsExtraView];
        return cell;
        
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
    InstructionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
    [cell setupInstructionsCellWithImage:self.instructionsImage text:self.instructionsText andExtraView:self.instructionsExtraView];
    return cell.bounds.size.height;
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
