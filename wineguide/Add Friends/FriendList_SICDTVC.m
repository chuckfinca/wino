//
//  FriendListSCDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/19/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendList_SICDTVC.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "FacebookProfileImageGetter.h"
#import "FacebookSessionManager.h"
#import <FBLoginView.h>
#import "FacebookFriendCell.h"
#import "FacebookLoginViewDelegate.h"
#import "InstructionsCell_FacebookConnect.h"

#define USER_ENTITY @"User2"
#define FACEBOOK_FRIEND_CELL @"Facebook Friend Cell"
#define NAVIGATION_BAR_OFFSET 20

@interface FriendList_SICDTVC ()

@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;
@property (nonatomic, strong) FacebookLoginViewDelegate *facebookLoginViewDelegate;

@end

@implementation FriendList_SICDTVC

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FacebookFriendCell" bundle:nil] forCellReuseIdentifier:FACEBOOK_FRIEND_CELL];
    
    self.searchBar.placeholder = @" Search friends...";
    
    InstructionsCell_FacebookConnect *instructionsCell = (InstructionsCell_FacebookConnect *)self.instructionsCell;
    instructionsCell.loginView.delegate = self.facebookLoginViewDelegate;
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

-(FacebookProfileImageGetter *)facebookProfileImageGetter
{
    if(!_facebookProfileImageGetter){
        _facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    }
    return _facebookProfileImageGetter;
}

-(FacebookLoginViewDelegate *)facebookLoginViewDelegate
{
    if(!_facebookLoginViewDelegate){
        _facebookLoginViewDelegate = [[FacebookLoginViewDelegate alloc] init];
        _facebookLoginViewDelegate.delegate = [FacebookSessionManager sharedInstance];
    }
    return _facebookLoginViewDelegate;
}


#pragma mark - Setup

-(void)registerInstructionCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionsCell_FacebookConnect" bundle:nil] forCellReuseIdentifier:INSTRUCTIONS_CELL_REUSE_IDENTIFIER];
}

-(void)removeInstructionsCell
{
    self.displayInstructionsCell = NO;
}

#pragma mark - SearchableCDTVC Required Methods


-(void)setupAndSearchFetchedResultsControllerWithText:(NSString *)text
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name_last_initial"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name_last"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name_first"
                                                              ascending:YES]];
    if([text length] > 0){
        request.predicate = [NSPredicate predicateWithFormat:@"name_full CONTAINS[cd] %@ && is_me == nil",[text lowercaseString]];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"is_me == nil"];
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"name_last_initial"
                                                                                   cacheName:nil];
    if([self.fetchedResultsController.fetchedObjects count] > 0){
        self.displayInstructionsCell = NO;
        self.displaySearchBar = YES;
    }
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    FacebookFriendCell *cell = (FacebookFriendCell *)[self.tableView dequeueReusableCellWithIdentifier:FACEBOOK_FRIEND_CELL forIndexPath:indexPath];
    
    User2 *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setupForUser:user];
    
    if(user.imageData){
        [cell.userProfileImageView setImage:[UIImage imageWithData:user.imageData]];
        
    } else {
        __weak UITableView *weakTableView = self.tableView;
        
        [self.facebookProfileImageGetter setProfilePicForUser:user inImageView:cell.userProfileImageView completion:^(BOOL success) {
            if(success){
                if([weakTableView cellForRowAtIndexPath:indexPath]){
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

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






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
