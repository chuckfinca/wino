//
//  FriendListVC.m
//  Corkie
//
//  Created by Charles Feinn on 3/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FriendListVC.h"
#import "ColorSchemer.h"

#define CORNER_RADIUS 4

@interface FriendListVC ()

@property (weak, nonatomic) IBOutlet UITextView *selectedFriendsTextView;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (weak, nonatomic) IBOutlet UIView *headerView;

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EmbeddedFriendList"]){
        NSLog(@"EmbeddedFriendList");
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
