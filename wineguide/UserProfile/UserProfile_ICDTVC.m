//
//  UserProfile_ICDTVC.m
//  Corkie
//
//  Created by Charles Feinn on 6/4/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UserProfile_ICDTVC.h"
#import "FacebookProfileImageGetter.h"
#import "FacebookLoginViewDelegate.h"
#import "FacebookSessionManager.h"
#import "GetMe.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "UserInformationCell.h"
#import "Cellar_SICDTVC.h"
#import "Timeline_TRSICDTVC.h"
#import "FollowingFollowedBy_FLSICDTVC.h"
#import "UserListCell.h"

#define USER_INFORMATION_CELL @"User information cell"
#define USER_PROFILE_LIST_ITEM_CELL @"User profile list item cell"

@interface UserProfile_ICDTVC () <ToggleFollowingButtonDelegate>

@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;
@property (nonatomic, strong) FacebookLoginViewDelegate *facebookLoginViewDelegate;

@property (nonatomic, strong) User2 *user;
@property (nonatomic, strong) UserInformationCell *userInformationCell;

@end

@implementation UserProfile_ICDTVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUser:(User2 *)user
{
    self = [super init];
    
    if(self){
        _user = user;
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile",user.name_first];
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInstructionsCell];
    [self.tableView registerClass:[UserListCell class] forCellReuseIdentifier:USER_PROFILE_LIST_ITEM_CELL];
}


#pragma mark - Getters & setters

-(User2 *)user
{
    if(!_user){
        _user = [GetMe sharedInstance].me;
        self.navigationItem.title = @"My Profile";
    }
    return _user;
}

-(UserInformationCell *)userInformationCell
{
    if(!_userInformationCell){
        _userInformationCell = [[[NSBundle mainBundle] loadNibNamed:@"UserInformationCell" owner:self options:nil] firstObject];
        [_userInformationCell setupForUser:self.user];
        _userInformationCell.delegate = self;
    }
    return _userInformationCell;
}

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

-(void)setupInstructionsCell
{
    if(self.user.facebook_id){
        self.displayInstructionsCell = NO;
        
    } else {
        FBLoginView *loginView = [[FBLoginView alloc] init];
        loginView.publishPermissions = FACEBOOK_DEFAULT_PERMISSIONS;
        loginView.delegate = self.facebookLoginViewDelegate;
        
        [self setupInstructionCellWithImage:[[UIImage imageNamed:@"user_default.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                       text:@"Create a profile and:\n・add friends to your tasting records\n・see which wines your friends like\n・sync your devices\n・etc."
                               andExtraView:loginView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.displayInstructionsCell){
        return 1;
    } else {
        return 5;
    }
}

-(UITableViewCell *)customTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row == 0){
        UserInformationCell *userInformationCell = (UserInformationCell *)self.userInformationCell;
        
        if(self.user.imageData){
            [userInformationCell.userProfileImageView setImage:[UIImage imageWithData:self.user.imageData]];
            
        } else {
            __weak UITableView *weakTableView = self.tableView;
            [self.facebookProfileImageGetter setProfilePicForUser:self.user inImageView:userInformationCell.userProfileImageView completion:^(BOOL success) {
                [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        
        cell = userInformationCell;
        
    } else {
        UserListCell *userListCell = [[UserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:USER_PROFILE_LIST_ITEM_CELL];
        [self setupUserListCell:userListCell atIndexPath:indexPath];
        
        cell = userListCell;
    }
    
    return cell;
}

-(void)setupUserListCell:(UserListCell *)userListCell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title;
    BOOL userInteractionEnabled = YES;
    
    switch (indexPath.row) {
        case 1:
            title = @"Cellar";
            userInteractionEnabled = [self.user.wines count] > 0;
            break;
        case 2:
            title = @"Tasting Records";
            userInteractionEnabled = [self.user.reviews count] > 0;
            break;
        case 3:
            title = @"Following";
            userInteractionEnabled = [self.user.following count] > 0;
            break;
        case 4:
            title = @"Followed By";
            userInteractionEnabled = [self.user.followedBy count] > 0;
            break;
            
        default:
            break;
    }
    
    [userListCell setupUserInteractionEnabled:userInteractionEnabled cellWithTitle:title];
}

#pragma mark - UITableViewDelegate

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return self.userInformationCell.bounds.size.height;
    } else {
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller;
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            controller = [[Cellar_SICDTVC alloc] initWithUser:self.user];
            break;
        case 2:
            controller = [[Timeline_TRSICDTVC alloc] initWithUser:self.user];
            break;
        case 3:
            NSLog(@"any user whose followedBy set contains the user %@ - %@",self.user.name_full, self.user.identifier);
            controller = [[FollowingFollowedBy_FLSICDTVC alloc] initWithUser:self.user predicate:[NSPredicate predicateWithFormat:@"ANY followedBy.facebook_id = %@",self.user.facebook_id] andPageTitle:@"Following"];
            break;
        case 4:
            NSLog(@"any user whose following set contains the user %@ - %@",self.user.name_full, self.user.identifier);
            controller = [[FollowingFollowedBy_FLSICDTVC alloc] initWithUser:self.user predicate:[NSPredicate predicateWithFormat:@"ANY following.facebook_id = %@",self.user.facebook_id] andPageTitle:@"Followed By"];
        default:
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Target action

-(void)toggleFollowing
{
    User2 *me = [GetMe sharedInstance].me;
    NSMutableSet *followedBy = [self.user.followedBy mutableCopy];
    
    if([followedBy containsObject:me]){
        [followedBy removeObject:me];
        self.userInformationCell.isFollowing = NO;
        
    } else {
        [followedBy addObject:me];
        self.userInformationCell.isFollowing = YES;
    }
    self.user.followedBy = followedBy;
    
    [self.tableView reloadData];
}








@end
