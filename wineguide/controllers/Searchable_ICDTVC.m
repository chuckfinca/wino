//
//  SearchableCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "Searchable_ICDTVC.h"
#import "MainTabBarController.h"
#import "DocumentHandler.h"
#import "ColorSchemer.h"

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
    self.tableView.backgroundColor = [ColorSchemer sharedInstance].customDarkBackgroundColor;
    
    self.searchBar.delegate = self;
    [self customizeSearchBar];
    [self setupAndSearchFetchedResultsControllerWithText:nil];
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

-(NSManagedObjectContext *)context
{
    if(!_context){
        if([DocumentHandler sharedDocumentHandler]){
            _context = [DocumentHandler sharedDocumentHandler].document.managedObjectContext;
            [self setupAndSearchFetchedResultsControllerWithText:nil];
            
        } else {
            [self listenForDocumentReadyNotification];
            NSLog(@"[DocumentHandler sharedDocumentHandler] does not exist (%@). Did start listening to DocumentReady notifications",[DocumentHandler sharedDocumentHandler]);
        }
    }
    return _context;
}

#pragma mark - Setup


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

#pragma mark - Listen for Notifications

-(void)listenForDocumentReadyNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupAndSearchFetchedResultsControllerWithText:)
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
