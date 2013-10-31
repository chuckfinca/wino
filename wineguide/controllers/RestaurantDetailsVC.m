//
//  RestaurantDetailsViewController.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDetailsVC.h"
#import "VariableHeightTV.h"

@interface RestaurantDetailsVC ()

@property (weak, nonatomic) IBOutlet VariableHeightTV *restaurantNameTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *streetAddressTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *cityAndStateTV;

@end

@implementation RestaurantDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 125);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define V_HEIGHT 20

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    self.restaurantNameTV.attributedText = [[NSAttributedString alloc] initWithString:restaurant.name attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}];
    [self.restaurantNameTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:restaurant.name] andMinimumHeight:V_HEIGHT];
    
    self.streetAddressTV.attributedText = [[NSAttributedString alloc] initWithString:restaurant.address attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    [self.streetAddressTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:restaurant.address] andMinimumHeight:V_HEIGHT];
    
    NSString *cityState = [NSString stringWithFormat:@"%@, %@",restaurant.city, restaurant.state];
    self.cityAndStateTV.attributedText = [[NSAttributedString alloc] initWithString:cityState attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];
    [self.cityAndStateTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:cityState] andMinimumHeight:V_HEIGHT];
}

@end
