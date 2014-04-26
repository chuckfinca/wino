//
//  RatingVC.m
//  Corkie
//
//  Created by Charles Feinn on 4/25/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "RatingVC.h"

@interface RatingVC ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ratingButtonsCollection;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeRating:(UIButton *)sender
{
    self.rating = sender.tag+1;
    NSLog(@"tag = %i",sender.tag);
    UIImage *image;
    for (UIButton *button in self.ratingButtonsCollection){
        if(button.tag < self.rating){
            image = [UIImage imageNamed:@"glass_full.png"];
        } else {
            image = [UIImage imageNamed:@"glass_empty.png"];
        }
        [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}

@end
