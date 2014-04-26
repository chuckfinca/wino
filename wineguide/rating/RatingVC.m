//
//  RatingVC.m
//  Corkie
//
//  Created by Charles Feinn on 4/25/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingVC.h"
#import "ColorSchemer.h"

@interface RatingVC ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ratingButtonsCollection;
@property (nonatomic, strong) UIColor *color;

@end

@implementation RatingVC

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
    // Do any additional setup after loading the view from its nib.
    for (UIButton *button in self.ratingButtonsCollection){
        [button setImage:[[UIImage imageNamed:@"glass_empty.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                forState:UIControlStateNormal];
        button.tintColor = [ColorSchemer sharedInstance].lightGray;
    }
}

-(void)setWineColor:(COWineColor)wineColor
{
    switch (wineColor) {
        case 0:
            self.color = [ColorSchemer sharedInstance].redWine;
            break;
        case 1:
            self.color = [ColorSchemer sharedInstance].whiteWine;
            break;
        case 2:
            self.color = [ColorSchemer sharedInstance].roseWine;
            break;
            
        default:
            break;
    }
    self.view.tintColor = self.color;
}


-(IBAction)changeRating:(UIButton *)sender
{
    self.rating = sender.tag+1;
    
    UIImage *image;
    for (UIButton *button in self.ratingButtonsCollection){
        if(button.tag < self.rating){
            image = [UIImage imageNamed:@"glass_full.png"];
            button.tintColor = self.color;
        } else {
            image = [UIImage imageNamed:@"glass_empty.png"];
            button.tintColor = [ColorSchemer sharedInstance].lightGray;
        }
        [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
