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

@property (weak, nonatomic) IBOutlet VariableHeightTV *restaurantDetailsTV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation RestaurantDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 140);
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
    NSString *textViewString = @"";
    NSRange nameRange = NSMakeRange(0, 0);
    NSRange addressRange = NSMakeRange(0, 0);
    
    
    if(restaurant.name){
        nameRange = NSMakeRange([textViewString length], [restaurant.name length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.name capitalizedString]]];
    }
    if(restaurant.address){
        addressRange = NSMakeRange([textViewString length]+1, [restaurant.address length]);
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[restaurant.address capitalizedString]]];
    }
    if(restaurant.city){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[restaurant.city capitalizedString]]];
    }
    if(restaurant.city && restaurant.state){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@", "]];
    }
    if(restaurant.state){
        textViewString = [textViewString stringByAppendingString:[NSString stringWithFormat:@"%@",[restaurant.state capitalizedString]]];
    }
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:textViewString];
    self.restaurantDetailsTV.attributedText = attributedText;
    self.restaurantDetailsTV.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    [self.restaurantDetailsTV.textStorage addAttribute:NSFontAttributeName
                                              value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                              range:nameRange];
    
    [self.restaurantDetailsTV setHeightConstraintForAttributedText:attributedText andMinimumHeight:V_HEIGHT];
    
}

- (IBAction)refreshList:(UISegmentedControl *)sender {
    NSLog(@"sender.tag = %i",sender.selectedSegmentIndex);
    [self.delegate loadWineList:sender.selectedSegmentIndex];
}

@end
