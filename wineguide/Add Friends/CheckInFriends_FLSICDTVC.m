//
//  CheckInFriends_FLSICDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 6/10/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "CheckInFriends_FLSICDTVC.h"
#import "FacebookSessionManager.h"
#import "FacebookLoginViewDelegate.h"

#define NAVIGATION_BAR_OFFSET 20

@interface CheckInFriends_FLSICDTVC ()

@property (nonatomic, strong) FacebookLoginViewDelegate *facebookLoginViewDelegate;

@end

@implementation CheckInFriends_FLSICDTVC

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
    [self setupInstructionsCell];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeInstructionsCell) name:FACEBOOK_LOGIN_SUCCESSFUL object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getters & setters

-(FacebookLoginViewDelegate *)facebookLoginViewDelegate
{
    if(!_facebookLoginViewDelegate){
        _facebookLoginViewDelegate = [[FacebookLoginViewDelegate alloc] init];
        _facebookLoginViewDelegate.delegate = [FacebookSessionManager sharedInstance];
    }
    return _facebookLoginViewDelegate;
}

#pragma mark - Setup

-(void)setupInstructionsCell
{
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self.facebookLoginViewDelegate;
    
    [self setupInstructionCellWithImage:nil
                                   text:@"Connect with Facebook to add friends to this tasting record."
                           andExtraView:loginView];
}

-(void)removeInstructionsCell
{
    self.displaySearchBar = YES;
    self.displayInstructionsCell = NO;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User2 *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate addOrRemoveUser:user];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User2 *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate addOrRemoveUser:user];
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarSearchButtonClicked:searchBar];
    [self.delegate animateNavigationBarBarTo:NAVIGATION_BAR_OFFSET];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
    [self.delegate animateNavigationBarBarTo:NAVIGATION_BAR_OFFSET];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.delegate animateNavigationBarBarTo:-NAVIGATION_BAR_OFFSET];
    return true;
}














@end
