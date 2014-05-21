//
//  ProfileVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UserProfileVC.h"
#import <FBLoginView.h>
#import <FBGraphUser.h>
#import "FacebookSessionManager.h"
#import "GetMe.h"
#import "Timeline_TRSICDTVC.h"
#import "Cellar_SICDTVC.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "FacebookProfileImageGetter.h"

#define USER_PROFILE_PAGE_CELL  @"UserCell"
#define USER_ENTITY  @"User2"

@interface UserProfileVC () <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) User2 *user;
@property (nonatomic, strong) User2 *me;
@property (nonatomic) BOOL following;


// Vertical constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToUserImageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewToBottomConstraint;


@end

@implementation UserProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    _user = user;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"UserDetails" owner:self options:nil] firstObject];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:USER_PROFILE_PAGE_CELL];
    
    if(!self.user || (self.user.is_me && !self.user.registered)){
        self.user = self.me;
        self.followButton.hidden = YES;
        self.tableView.hidden = YES;
    } else {
        self.loginView.hidden = YES;
    }
    
    if(self.user.is_me){
        self.title = @"Me";
        self.followButton.hidden = YES;
    } else {
        self.title = @"Profile";
    }
    
    [self setupNameLabel];
    [self setupUserProfileImage];
    [self setupFollowButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHeaderViewHeight];
}


#pragma mark - Setup

-(User2 *)me
{
    if(!_me){
        _me = [GetMe sharedInstance].me;
    }
    return _me;
}

-(void)setupNameLabel
{
    NSString *text;
    if(self.user.name_first){
        text = [NSString stringWithFormat:@"%@ %@.",self.user.name_first, [self.user.name_last substringToIndex:1]];
    } else {
        if(self.user.is_me){
            text = @"Create a profile and:\n・add friends to your tasting records\n・see which wines your friends like and are drinking\n・sync your devices\n・etc.";
        } else {
            text = @"";
        }
    }
    self.nameLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[FontThemer sharedInstance].secondaryBodyTextAttributes];
}

-(void)setupUserProfileImage
{
    FacebookProfileImageGetter *fpig = [[FacebookProfileImageGetter alloc] init];
    [fpig setProfilePicForUser:self.user inImageView:self.userProfileImageView completion:^(BOOL success) {
        if(success){
            NSLog(@"successfully set user profile pic");
        } else {
            NSLog(@"failed to set user profile pic");
        }
    }];
    
    UIColor *color = [ColorSchemer sharedInstance].gray;
    self.userProfileImageView.tintColor = color;
    self.userProfileImageView.layer.borderWidth = 2;
    self.userProfileImageView.layer.borderColor = color.CGColor;
    self.userProfileImageView.layer.cornerRadius = 4;
}

-(void)setHeaderViewHeight
{
    float height = 0;
    
    height += self.topToUserImageViewConstraint.constant;
    height += self.userProfileImageView.bounds.size.height;
    height += self.userImageViewToBottomConstraint.constant;
    
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, height);
}

-(void)setupFollowButton
{
    if([self.user.followedBy containsObject:self.me]){
        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        self.following = YES;
    } else {
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        self.following = NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_PROFILE_PAGE_CELL forIndexPath:indexPath];
    
    NSString *title;
    
    switch (indexPath.row) {
        case 0:
            title = @"Cellar (#)";
            break;
        case 1:
            title = [NSString stringWithFormat:@"Tasting Records (%i)",[self.user.reviews count]];
            break;
        case 2:
            title = [NSString stringWithFormat:@"Following (%i)",[self.user.following count]];
            break;
        case 3:
            title = [NSString stringWithFormat:@"Followed by (%i)",[self.user.followedBy count]];
            break;
        default:
            break;
    }
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller;
    switch (indexPath.row) {
    case 0:
            controller = [[Cellar_SICDTVC alloc] init];
        break;
    case 1:
            controller = [[Timeline_TRSICDTVC alloc] initWithNibName:nil bundle:nil];
        break;
    case 2:
        break;
    case 3:
        break;
    default:
        break;
}
    [self.navigationController pushViewController:controller animated:YES];
}



#pragma mark - FBLoginViewDelegate

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSLog(@"loginView is now in logged in mode");
    NSLog(@"user.id = %@",user.id);
    NSLog(@"user.name = %@",user.name);
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedInUser...");
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedOutUser...");
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"FBLoginViewDelegate - There was a communication or authorization error - %@.",error.localizedDescription);
    [[FacebookSessionManager sharedInstance] sessionStateChanged:nil state:0 error:error];
}


#pragma mark - Target action

-(IBAction)followUser:(id)sender
{
    NSMutableSet *followedBy = [self.user.followedBy mutableCopy];
    if(self.following){
        [followedBy removeObject:self.me];
    } else {
        [followedBy addObject:self.me];
    }
    self.user.followedBy = followedBy;
    
    [self displayFollowMessage];
    [self setupFollowButton];
}

-(void)displayFollowMessage
{
    NSString *message;
    
    if(!self.following){
        message = @"Added as a trusted reviewer";
    } else {
        message = @"Unfollowed";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:message otherButtonTitles: nil];
    [alert show];
    
    NSArray *arguments = @[@1,@1];
    [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:arguments afterDelay:1.5f];
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
