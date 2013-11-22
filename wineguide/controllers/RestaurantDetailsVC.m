//
//  RestaurantDetailsViewController.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "RestaurantDetailsVC.h"
#import "RestaurantDetailsVHTV.h"

@interface RestaurantDetailsVC ()

@property (weak, nonatomic) IBOutlet RestaurantDetailsVHTV *restaurantDetailsTV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation RestaurantDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 127);
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

-(void)setupWithRestaurant:(Restaurant *)restaurant
{
    [self.restaurantDetailsTV setupTextViewWithRestaurant:restaurant];
}


- (IBAction)refreshList:(UISegmentedControl *)sender {
    [self.delegate loadWineList:sender.selectedSegmentIndex];
}

@end
