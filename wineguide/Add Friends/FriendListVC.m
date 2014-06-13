//
//  FriendListVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendListVC.h"
#import "ColorSchemer.h"
#import "FontThemer.h"
#import "UIView+BorderDrawer.h"

@interface FriendListVC ()

@property (weak, nonatomic) IBOutlet UITextView *selectedFriendsTextView;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIView *friendListContainerView;
@property (weak, nonatomic) IBOutlet UIButton *shareToFacebookButton;
@property (weak, nonatomic) IBOutlet UIView *shareContainerView;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) CheckInFriends_FLSICDTVC *checkInFriends_FLSICDTVC;
@property (nonatomic) BOOL checkInComplete;


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
    
    [self setupTextView];
    
    [self.checkInButton setAttributedTitle:[[NSAttributedString alloc] initWithString:self.checkInButton.titleLabel.text attributes:@{NSFontAttributeName : [FontThemer sharedInstance].headline}] forState:UIControlStateNormal];
    [self.checkInButton sizeToFit];
    
    self.shareLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Share:" attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    
    self.shareContainerView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    [self.shareContainerView drawBorderWidth:1 withColor:[ColorSchemer sharedInstance].gray onTop:YES bottom:YES left:NO andRight:NO];
    
    [self.shareToFacebookButton setImage:[[UIImage imageNamed:@"share_facebook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.shareToFacebookButton.tintColor = [ColorSchemer sharedInstance].gray;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(!self.checkInComplete){
        [self.delegate backFromVC:self withFriends:self.selectedFriends];
    }
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
        if([segue.destinationViewController isKindOfClass:[CheckInFriends_FLSICDTVC class]]){
            self.checkInFriends_FLSICDTVC = (CheckInFriends_FLSICDTVC *)segue.destinationViewController;
            self.checkInFriends_FLSICDTVC.delegate = self;
        }
    }
}


#pragma mark - Target Action

-(IBAction)checkIn:(id)sender
{
    self.checkInComplete = YES;
    [self.delegate checkInWithFriends:self.selectedFriends shareToFacebook:self.shareToFacebookButton.selected];
}

-(IBAction)shareToFacebook:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if(sender.selected == YES){
        sender.tintColor = self.view.tintColor;
    } else {
        sender.tintColor = [ColorSchemer sharedInstance].gray;
    }
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
