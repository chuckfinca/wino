//
//  ProfileVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "UserProfileTVController.h"
#import <FBLoginView.h>
#import <FBGraphUser.h>
#import "FacebookSessionManager.h"
#import "DocumentHandler.h"

#define USER_PROFILE_PAGE_CELL  @"UserCell"
#define USER_ENTITY  @"User"

@interface UserProfileTVController () <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, strong) User *user;


// Vertical constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToUserImageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewToBottomConstraint;


@end

@implementation UserProfileTVController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUser:(User *)user
{
    self = [super init];
    _user = user;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"UserDetails" owner:self options:nil] firstObject];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:USER_PROFILE_PAGE_CELL];
    self.title = @"Profile";
    
    if(!self.user){
        [self getMe];
    }
    [self setupHeader];
}

-(void)viewWillLayoutSubviews
{
    [self setViewHeight];
}


#pragma mark - Setup

-(void)getMe
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"isMe = YES"];
    
    NSError *error;
    NSArray *matches = [[DocumentHandler sharedDocumentHandler].document.managedObjectContext executeFetchRequest:request error:&error];
    if(matches){
        self.user = [matches firstObject];
    } else {
        NSLog(@"getMe - User not found!");
    }
    
    self.title = @"Me";
}

-(void)setupHeader
{
    self.nameLabel.text = self.user.nameFull;
    [self.userProfileImageView setImage:[UIImage imageWithData:self.user.profileImage]];
}

-(void)setViewHeight
{
    float height = 0;
    
    NSLog(@"%f",height);
    height += self.topToUserImageViewConstraint.constant;
    NSLog(@"%f",height);
    height += self.userProfileImageView.bounds.size.height;
    NSLog(@"%f",height);
    height += self.userImageViewToBottomConstraint.constant;
    
    NSLog(@"%f",height);
    self.tableView.tableHeaderView.bounds = CGRectMake(0, 0, self.tableView.tableHeaderView.bounds.size.width, height);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_PROFILE_PAGE_CELL forIndexPath:indexPath];
    
    NSString *title;
    
    switch (indexPath.row) {
        case 0:
            title = @"Cellar (#)";
            break;
        case 1:
            title = @"Tasting Records (#)";
            break;
        case 2:
            title = @"Following (#)";
            break;
        case 3:
            title = @"Followers (#)";
            break;default:
            break;
    }
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate






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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
