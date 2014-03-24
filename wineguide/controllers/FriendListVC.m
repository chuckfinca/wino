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

#define CORNER_RADIUS 4

@interface FriendListVC () <FriendSelectionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *selectedFriendsTextView;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) FriendListSCDTVC *friendListSCDTVC;
@property (nonatomic, strong) NSMutableArray *selectedFriends;

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
    self.headerView.backgroundColor = [ColorSchemer sharedInstance].baseColor;
    
    [self setupBackground];
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
    
    NSLog(@"text = %@",text);
    for(User *u in self.selectedFriends){
        
        if(!text) {
            NSLog(@"aaa");
            text = @"";
        } else {
            NSLog(@"bbb");
            text = [text stringByAppendingString:@", "];
        }
        NSString *name = [NSString stringWithFormat:@"%@ %@",u.nameFirst, u.nameLast];
        NSLog(@"name = %@",name);
        text = [text stringByAppendingString:name];
    }
    self.selectedFriendsTextView.attributedText = [[NSAttributedString alloc] initWithString:text];
    NSLog(@"text = %@",text);
    NSLog(@"friends = %i",[self.selectedFriends count]);
    [self.selectedFriendsTextView setNeedsDisplay];
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

-(void)addUser:(User *)user
{
    [self.selectedFriends addObject:user];
    [self setupTextView];
}

-(void)removeUser:(User *)user
{
    [self.selectedFriends removeObject:user];
    [self setupTextView];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
