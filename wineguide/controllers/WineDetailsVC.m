//
//  WineDetailsVC.m
//  wineguide
//
//  Created by Charles Feinn on 10/28/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "WineDetailsVC.h"
#import "VariableHeightTV.h"

@interface WineDetailsVC ()

@property (weak, nonatomic) IBOutlet VariableHeightTV *wineNameTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *yearTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *varietalTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *regionTV;
@property (weak, nonatomic) IBOutlet VariableHeightTV *alcoholPercentageTV;
@property (weak, nonatomic) IBOutlet UILabel *numReviewsLabel;

@end

@implementation WineDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupTextViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define V_HEIGHT 20

-(void)setupTextViews
{
    [self.wineNameTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:@"vineyard"] andMinimumHeight:V_HEIGHT];
    [self.yearTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:@"year"] andMinimumHeight:V_HEIGHT];
    [self.varietalTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:@"varietal"] andMinimumHeight:V_HEIGHT];
    [self.regionTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:@"region"] andMinimumHeight:V_HEIGHT];
    [self.alcoholPercentageTV setHeightConstraintForAttributedText:[[NSAttributedString alloc] initWithString:@"additional info"] andMinimumHeight:V_HEIGHT];
}

@end
