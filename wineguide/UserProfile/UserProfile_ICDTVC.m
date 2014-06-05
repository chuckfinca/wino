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


@interface UserProfile_ICDTVC ()

@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;
@property (nonatomic, strong) FacebookLoginViewDelegate *facebookLoginViewDelegate;

@property (nonatomic, strong) User2 *user;

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
    _user = user;
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.user.name_display;
    
    [self setupInstructionsCell];
}


#pragma mark - Getters & setters

-(User2 *)user
{
    if(!_user){
        _user = [GetMe sharedInstance].me;
    }
    return _user;
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
    return [UITableViewCell new];
}

#pragma mark - UITableViewDataSource
/*
-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath; // Abstract
-(UIView *)viewForHeaderInSection:(NSInteger)section; // Abstract
-(CGFloat)heightForHeaderInSection:(NSInteger)section; // Abstract
-(NSString *)titleForHeaderInSection:(NSInteger)section; // Abstract
-(void)userDidSelectRowAtIndexPath:(NSIndexPath *)indexPath; // Abstract
*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
