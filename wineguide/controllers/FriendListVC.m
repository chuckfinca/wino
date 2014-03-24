//
//  FriendListVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendListVC.h"
#import "ColorSchemer.h"
#import "FriendListSCDTVC.h"
#import "FontThemer.h"

#define CORNER_RADIUS 4

@interface FriendListVC () <FriendSelectionDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITextView *selectedFriendsTextView;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) FriendListSCDTVC *friendListSCDTVC;
@property (nonatomic, strong) NSMutableArray *selectedFriends;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;

@end

@implementation FriendListVC

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
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.headerView.backgroundColor = [ColorSchemer sharedInstance].baseColor;
    
    [self setupBackground];
    [self setupTextView];
    
    
    [self customizeSearchBar];
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

#pragma mark - Setup

-(void)customizeSearchBar
{
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @" Search friends...";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.searchBar.barTintColor = [ColorSchemer sharedInstance].customWhite;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.searchBar setSearchFieldBackgroundImage:blank forState:UIControlStateNormal];
    
    [self.searchBar.layer setBorderColor:[ColorSchemer sharedInstance].lightGray.CGColor];
    [self.searchBar.layer setBorderWidth:1];
}

#pragma mark - Getters & Setters

-(UIImage *)placeHolderImage
{
    if(!_placeHolderImage){
        _placeHolderImage = [[UIImage alloc] init];
    }
    return _placeHolderImage;
}

-(NSMutableArray *)selectedFriends
{
    if(!_selectedFriends){
        _selectedFriends = [[NSMutableArray alloc] init];
    }
    return _selectedFriends;
}


#pragma mark - Setup

-(void)setupBackground
{
    CALayer *layer = self.view.layer;
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setShadowColor:[ColorSchemer sharedInstance].shadowColor.CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.2];
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
}

-(void)setupTextView
{
    NSString *text;
    
    for(User *u in self.selectedFriends){
        
        if(!text) {
            text = @"";
        } else {
            text = [text stringByAppendingString:@", "];
        }
        NSString *name = [NSString stringWithFormat:@"%@ %@",u.nameFirst, u.nameLast];
        text = [text stringByAppendingString:name];
    }
    
    BOOL instructions = NO;
    
    if(!text){
        text = [NSString stringWithFormat:@"Who did you try the %@ with?",self.wineName];
        instructions = YES;
    }
    
    self.selectedFriendsTextView.attributedText = [[NSAttributedString alloc] initWithString:text];
    
    if(instructions){
        [self.selectedFriendsTextView.textStorage addAttribute:NSForegroundColorAttributeName
                                                         value:[ColorSchemer sharedInstance].textSecondary
                                                         range:NSMakeRange(0, [self.selectedFriendsTextView.text length])];
    } else {
        [self.selectedFriendsTextView.textStorage addAttribute:NSForegroundColorAttributeName
                                                         value:[ColorSchemer sharedInstance].textPrimary
                                                         range:NSMakeRange(0, [self.selectedFriendsTextView.text length])];
    }
    
    [self.selectedFriendsTextView.textStorage addAttribute:NSFontAttributeName
                                                     value:[FontThemer sharedInstance].body
                                                     range:NSMakeRange(0, [self.selectedFriendsTextView.text length])];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EmbeddedFriendList"]){
        if([segue.destinationViewController isKindOfClass:[FriendListSCDTVC class]]){
            self.friendListSCDTVC = (FriendListSCDTVC *)segue.destinationViewController;
            self.friendListSCDTVC.delegate = self;
        }
    }
}


#pragma mark - Target Action

-(IBAction)backToDetails:(id)sender
{
    [self.delegate backFromVC:self];
}
-(IBAction)checkIn:(id)sender
{
    [self.delegate checkIn];
}

#pragma mark - FriendSelectionDelegate

-(void)addOrRemoveUser:(User *)user
{
    if([self.selectedFriends containsObject:user]){
        [self.selectedFriends removeObject:user];
    } else {
        [self.selectedFriends addObject:user];
    }
    [self setupTextView];
}










#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.friendListSCDTVC setupAndSearchFetchedResultsControllerWithText:searchText];
    self.searchBar.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // NSLog(@"searchBarCancelButtonClicked...");
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    [self.friendListSCDTVC setupAndSearchFetchedResultsControllerWithText:nil];
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
    float animationTime = 0.3;
    NSInteger yOffset = 40;
    NSInteger viewHeightAdjustment = 165;
    
    if(notification.name == UIKeyboardWillShowNotification){
        [self.searchBar setShowsCancelButton:YES animated:YES];
        [UIView animateWithDuration:animationTime animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-yOffset, self.view.frame.size.width, self.view.frame.size.height-viewHeightAdjustment);
            self.backButton.hidden = YES;
            self.checkInButton.hidden = YES;
            
        }];
    } else {
        [self.searchBar setShowsCancelButton:NO animated:NO];
        [UIView animateWithDuration:animationTime animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+yOffset, self.view.frame.size.width, self.view.frame.size.height+viewHeightAdjustment);
            self.backButton.hidden = NO;
            self.checkInButton.hidden = NO;
        }];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
