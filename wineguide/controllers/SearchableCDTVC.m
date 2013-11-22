//
//  SearchableCDTVC.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "SearchableCDTVC.h"

@interface SearchableCDTVC () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

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
    [self setupSearchBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self listenForKeyboardNotifcations];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setupSearchBar
{
    self.searchBar.delegate = self;
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"searchText = %@",searchText);
    [self searchFetchedResultsForText:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    //NSString *input = searchBar.text;
    //NSLog(@"input = %@",input);
    
    if([self.fetchedResultsController.fetchedObjects count] == 0){
        [self getMoreResultsFromTheServer];
    }
    
}

-(void)getMoreResultsFromTheServer
{
    NSLog(@"getMoreResultsFromTheServer...");
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // NSLog(@"searchBarCancelButtonClicked...");
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self setupFetchedResultsController];
}

-(void)searchFetchedResultsForText:(NSString *)text
{
    // Abstract
}

-(void)setupFetchedResultsController
{
    // Abstract
}


#pragma mark - Listen for Notifications

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
