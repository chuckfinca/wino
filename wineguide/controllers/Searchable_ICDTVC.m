//
//  SearchableCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Searchable_ICDTVC.h"
#import "MainTabBarController.h"
#import "DocumentHandler2.h"
#import "ColorSchemer.h"
#import "UIView+BorderDrawer.h"

@implementation Searchable_ICDTVC

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
    self.tableView.backgroundColor = [ColorSchemer sharedInstance].lightGray;
    self.tableView.separatorColor = [ColorSchemer sharedInstance].gray;
    self.tableView.sectionIndexBackgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.tableView.sectionIndexColor = [ColorSchemer sharedInstance].baseColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self listenForKeyboardNotifcations];
    
    [self refreshFetchedResultsController];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getters & setters

-(NSManagedObjectContext *)context
{
    if(!_context){
        if([DocumentHandler2 sharedDocumentHandler]){
            _context = [DocumentHandler2 sharedDocumentHandler].document.managedObjectContext;
            
        } else {
            [self listenForDocumentReadyNotification];
            NSLog(@"[DocumentHandler sharedDocumentHandler] does not exist (%@). Did start listening to DocumentReady notifications",[DocumentHandler2 sharedDocumentHandler]);
        }
    }
    return _context;
}

-(void)setDisplaySearchBar:(BOOL)displaySearchBar
{
    if(displaySearchBar == YES){
        self.tableView.tableHeaderView = self.searchBar;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

-(NSString *)currentSearchString
{
    return [self.searchBar.text length] > 0 ? self.searchBar.text : nil;
}

#pragma mark - Setup


-(UISearchBar *)searchBar
{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _searchBar.delegate = self;
        
        _searchBar.barTintColor = [ColorSchemer sharedInstance].customWhite;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
        UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [_searchBar setSearchFieldBackgroundImage:blank forState:UIControlStateNormal];
        
        [_searchBar drawBorderColor:[ColorSchemer sharedInstance].gray onTop:YES bottom:YES left:NO andRight:NO];
    }
    return _searchBar;
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshFetchedResultsController];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
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
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self refreshFetchedResultsController];
}

-(void)refreshFetchedResultsController
{
    // Abstract
}

#pragma mark - Listen for Notifications

-(void)listenForDocumentReadyNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFetchedResultsController)
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
        [_searchBar setShowsCancelButton:YES animated:YES];
    } else {
        [_searchBar setShowsCancelButton:NO animated:NO];
    }
}







@end
