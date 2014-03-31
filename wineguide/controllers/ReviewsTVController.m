//
//  ReviewsTVController.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewsTVController.h"
#import "Review.h"
#import "ReviewCell.h"
#import "User.h"
#import "Wine.h"
#import "WineNameVHTV.h"
#import "DateStringFormatter.h"

#define REVIEW_CELL @"ReviewCell"

@interface ReviewsTVController ()

@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) ReviewCell *sizingCell;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;


@end

@implementation ReviewsTVController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewCell" bundle:nil] forCellReuseIdentifier:REVIEW_CELL];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)setupFromTastingRecord:(TastingRecord *)tastingRecord
{
    self.reviews = [tastingRecord.reviews sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"reviewDate" ascending:NO]]];
    
    self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ReviewsTVControllerHeaderView" owner:self options:nil] firstObject];
    
    Review *review = (Review *)self.reviews[0];
    self.dateLabel.attributedText = [DateStringFormatter attributedStringFromDate:tastingRecord.tastingDate];
    [self.wineNameVHTV setupTextViewWithWine:review.wine fromRestaurant:tastingRecord.restaurant];
}


#pragma mark - Getters & setters

-(ReviewCell *)sizingCell
{
    if(!_sizingCell){
        _sizingCell = [self.tableView dequeueReusableCellWithIdentifier:REVIEW_CELL];
    }
    return _sizingCell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewCell *cell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:REVIEW_CELL forIndexPath:indexPath];
    
    Review *review = self.reviews[indexPath.row];
    User *user = review.user;
    
    [cell setupReviewWithUserName:[NSString stringWithFormat:@"%@ %@.",user.nameFirst, user.nameLastInitial]
                        userImage:[UIImage imageWithData:user.profileImage]
                       reviewText:review.reviewText
                        wineColor:review.wine.color
                        andRating:review.rating];
    
    return cell;
}

#pragma mark - UITableViewDelegate


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Review *review = self.reviews[indexPath.row];
    
    [self.sizingCell setupReviewWithUserName:nil userImage:nil reviewText:review.reviewText wineColor:nil andRating:nil];
    return self.sizingCell.bounds.size.height;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}











@end
