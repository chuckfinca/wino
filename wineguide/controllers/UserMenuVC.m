//
//  UserMenuVC.m
//  Gimme
//
//  Created by Charles Feinn on 11/26/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "UserMenuVC.h"
#import "ColorSchemer.h"
#import "RestaurantGroupManagerTVC.h"

@interface UserMenuVC ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateRestaurantButton;


@end

@implementation UserMenuVC

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
    self.view.backgroundColor = [ColorSchemer sharedInstance].menuBackgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

-(RestaurantGroupManagerTVC *)restaurantManagerTVC
{
    NSString *storyboardName;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        storyboardName =  @"Restauranteur_iPad";
    } else {
        storyboardName =  @"Restauranteur_iPhone";
    }
    return [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateInitialViewController];
}

- (IBAction)updateRestaurant:(UIButton *)sender
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self presentViewController:self.restaurantManagerTVC animated:YES completion:^{}];
}



@end
