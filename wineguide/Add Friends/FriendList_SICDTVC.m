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
#import "FacebookFriendCell.h"
#import "FacebookLoginViewDelegate.h"
#import "GetMe.h"

#define USER_ENTITY @"User2"
#define FACEBOOK_FRIEND_CELL @"Facebook Friend Cell"

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
}


#pragma mark - Getters & setters

-(FacebookProfileImageGetter *)facebookProfileImageGetter
{
    if(!_facebookProfileImageGetter){
        _facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    }
    return _facebookProfileImageGetter;
}

-(User2 *)user
{
    if(!_user){
        _user = [GetMe sharedInstance].me;
    }
    return _user;
}

-(NSPredicate *)predicate
{
    if(!_predicate){
        _predicate = [NSPredicate predicateWithFormat:@"ANY followedBy.identifier = %@",self.user.identifier];
    }
    return _predicate;
}



#pragma mark - SearchableCDTVC Required Methods


-(void)refreshFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name_last_initial"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name_last"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name_first"
                                                              ascending:YES]];
    if([self.currentSearchString length] > 0){
        request.predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                        subpredicates:@[self.predicate, [NSPredicate predicateWithFormat:@"name_full CONTAINS[cd] %@",[self.currentSearchString lowercaseString]]]];
    } else {
        request.predicate = self.predicate;
    }
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"name_last_initial"
                                                                                   cacheName:nil];
    if([self.fetchedResultsController.fetchedObjects count] > 0){
        self.displayInstructionsCell = NO;
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
    if([self.fetchedResultsController.fetchedObjects count] > 20){
        return [self.fetchedResultsController sectionIndexTitles];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}









@end
