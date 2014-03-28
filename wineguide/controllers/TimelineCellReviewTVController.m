//
//  TimelineCellReviewTVController.m
//  Corkie
//
//  Created by Charles Feinn on 3/27/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimelineCellReviewTVController.h"
#import "Review.h"
#import "User.h"
#import "TimelineCellHeaderView.h"
#import "WineDetailsVHTV.h"
#import "TastingRecord.h"
#import "DateStringFormatter.h"
#import "FontThemer.h"
#import "ColorSchemer.h"

@interface TimelineCellReviewTVController ()

@property (nonatomic, strong) TastingRecord *tastingRecord;
@property (strong, nonatomic) IBOutlet TimelineCellHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineDetailsVHTV *wineNameTV;

@end

@implementation TimelineCellReviewTVController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
}


#pragma mark - Getters & Setters



#pragma mark - Setup

-(void)setupWithTastingRecord:(TastingRecord *)tastingRecord
{
    self.tastingRecord = tastingRecord;
    
    Review *randomReview = [tastingRecord.reviews anyObject];
    [self.wineNameTV setupTextViewWithWine:randomReview.wine fromRestaurant:self.tastingRecord.restaurant];
    
    [self setupDateLabel];
}

-(void)setupDateLabel
{
    NSString *localDateString = [DateStringFormatter formatStringForTimelineDate:self.tastingRecord.tastingDate];
    NSLog(@"localDateString = %@",localDateString);
    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:localDateString attributes:@{NSFontAttributeName : [FontThemer sharedInstance].caption2, NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary}];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tastingRecord.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
