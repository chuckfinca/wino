//
//  SearchableCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "SearchableCDTVC.h"
#import "MainTabBarController.h"
#import "DocumentHandler.h"
#import "ColorSchemer.h"

@interface SearchableCDTVC () <UISearchBarDelegate, UISearchDisplayDelegate>

@end

@implementation SearchableCDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self refresh];
    
    self.searchBar.delegate = self;
    
    [self customizeSearchBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self listenForKeyboardNotifcations];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getters & setters

-(UITableViewCell *)instructionsCell
{
    if(!_instructionsCell){
        _instructionsCell = [self.tableView dequeueReusableCellWithIdentifier:@"Instructions Cell"];
    }
    return _instructionsCell;
}


#pragma mark - Setup

-(void)refresh
{
    [self getManagedObjectContext];
    if (self.context){
        [self getMoreResultsFromTheServer];
        [self setupAndSearchFetchedResultsControllerWithText:nil];
    }
}

-(void)getManagedObjectContext
{
    if(!self.context && [DocumentHandler sharedDocumentHandler]){
        self.context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
    } else {
        [self listenForDocumentReadyNotification];
        NSLog(@"cannot get managed object context because either self.context exists (%@) or [DocumentHandler sharedDocumentHandler] does not exist (%@). Did start listening to DocumentReady notifications",self.context,[DocumentHandler sharedDocumentHandler]);
    }
}

-(void)customizeSearchBar
{
    self.searchBar.barTintColor = [ColorSchemer sharedInstance].customWhite;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.searchBar setSearchFieldBackgroundImage:blank forState:UIControlStateNormal];
    
    [self.searchBar.layer setBorderColor:[ColorSchemer sharedInstance].lightGray.CGColor];
    [self.searchBar.layer setBorderWidth:1];
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"searchText = %@",searchText);
    [self setupAndSearchFetchedResultsControllerWithText:searchText];
    self.searchBar.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    //NSString *input = searchBar.text;
    //NSLog(@"input = %@",input);
    
    if([self.fetchedResultsController.fetchedObjects count] == 0){
        
        // get more results from the server
    }
}

-(void)getMoreResultsFromTheServer
{
    // abstract
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // NSLog(@"searchBarCancelButtonClicked...");
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self setupAndSearchFetchedResultsControllerWithText:nil];
}

-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([self.fetchedResultsController.fetchedObjects count] > 0){
        return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    }
    return nil;
}

#pragma mark - Listen for Notifications

-(void)listenForDocumentReadyNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"Document Ready"
                                               object:nil];
}

-(void)listenForKeyboardNotifcations
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHideCancelButton:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHideCancelButton:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)showHideCancelButton:(NSNotification *)notification
{
    if(notification.name == UIKeyboardWillShowNotification){
        [self.searchBar setShowsCancelButton:YES animated:YES];
    } else {
        [self.searchBar setShowsCancelButton:NO animated:NO];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
