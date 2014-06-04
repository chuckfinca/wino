//
//  FriendListVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendListVC.h"
#import "ColorSchemer.h"
#import "FriendList_SICDTVC.h"
#import "FontThemer.h"
#import "UIView+BorderDrawer.h"

@interface FriendListVC () <FriendSelectionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *selectedFriendsTextView;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) FriendList_SICDTVC *friendListSCDTVC;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIView *friendListContainerView;

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
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customWhite;
    [self.friendListContainerView drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:YES bottom:NO left:NO andRight:NO];
    
    [self setupTextView];
    
    [self.checkInButton setAttributedTitle:[[NSAttributedString alloc] initWithString:self.checkInButton.titleLabel.text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].headline}] forState:UIControlStateNormal];
    [self.checkInButton sizeToFit];
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

-(void)setupTextView
{
    NSString *text;
    
    for(User2 *u in self.selectedFriends){
        
        if(!text) {
            text = @"";
        } else {
            text = [text stringByAppendingString:@", "];
        }
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@ %@",u.name_first, u.name_last]];
    }
    
    BOOL instructions = NO;
    
    if(!text){
        text = [NSString stringWithFormat:@"Who did you try the %@ with?",self.wineName];
        instructions = YES;
    }
    
    self.selectedFriendsTextView.attributedText = [[NSAttributedString alloc] initWithString:text];
    
    if(instructions){
        [self.selectedFriendsTextView.textStorage addAttribute:NSForegroundColorAttributeName
                                                         value:[ColorSchemer sharedInstance].textPlaceholder
                                                         range:NSMakeRange(0, [self.selectedFriendsTextView.text length])];
    } else {
        [self.selectedFriendsTextView.textStorage addAttribute:NSForegroundColorAttributeName
                                                         value:[ColorSchemer sharedInstance].textPrimary
                                                         range:NSMakeRange(0, [self.selectedFriendsTextView.text length])];
    }
    
    [self.selectedFriendsTextView.textStorage addAttribute:NSFontAttributeName
                                                     value:[FontThemer sharedInstance].body
                                                     range:NSMakeRange(0, [self.selectedFriendsTextView.text length])];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EmbeddedFriendList"]){
        if([segue.destinationViewController isKindOfClass:[FriendList_SICDTVC class]]){
            self.friendListSCDTVC = (FriendList_SICDTVC *)segue.destinationViewController;
            self.friendListSCDTVC.delegate = self;
        }
    }
}


#pragma mark - Target Action

-(IBAction)backToDetails:(id)sender
{
    [self.delegate backFromVC:self withFriends:self.selectedFriends];
}
-(IBAction)checkIn:(id)sender
{
    [self.delegate checkInWithFriends:self.selectedFriends];
}




#pragma mark - FriendSelectionDelegate

-(void)addOrRemoveUser:(User2 *)user
{
    if([self.selectedFriends containsObject:user]){
        [self.selectedFriends removeObject:user];
    } else {
        [self.selectedFriends addObject:user];
    }
    [self setupTextView];
}

-(void)animateNavigationBarBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        self.navigationController.navigationBar.frame = frame;
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+y*2.5, self.view.frame.size.width, self.view.frame.size.height);
        [self updateBarButtonItems:alpha];
    }];
}

-(void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
