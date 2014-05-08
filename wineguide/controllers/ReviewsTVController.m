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
#import "ColorSchemer.h"
#import "UserProfileVC.h"
#import "Wine_TRSICDTVC.h"

#define REVIEW_CELL @"ReviewCell"

@interface ReviewsTVController () <ReviewCellDelegate>

@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) ReviewCell *sizingCell;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToDateLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelToWineNameVHTVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wineNameVHTVToBottomConstraint;

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
    self.title = @"Tasting Record";
    
    self.view.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHeaderHeight];
}

-(void)setupFromTastingRecord:(TastingRecord *)tastingRecord
{
    self.reviews = [tastingRecord.reviews sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"reviewDate" ascending:NO]]];
    
    self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ReviewsTVControllerHeaderView" owner:self options:nil] firstObject];
    self.tableView.tableHeaderView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    
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


#pragma mark - Setup

-(void)setHeaderHeight
{
    float height = 0;
    
    height += self.topToDateLabelConstraint.constant;
    height += self.dateLabel.bounds.size.height;
    height += self.dateLabelToWineNameVHTVConstraint.constant;
    height += [self.wineNameVHTV height];
    height += self.wineNameVHTVToBottomConstraint.constant;
    
    self.tableView.tableHeaderView.bounds = CGRectMake(0,0,self.wineNameVHTV.bounds.size.width, height);
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
    
    cell.tag = indexPath.row;
    Review *review = self.reviews[indexPath.row];
    User *user = review.user;
    
    NSString *userName;
    if(user.isMe){
        userName = @"Me";
    } else {
        [NSString stringWithFormat:@"%@ %@.",user.nameFirst, user.nameLastInitial];
    }
    
    [cell setupClaimed:[review.claimedByUser boolValue]
    reviewWithUserName:userName
             userImage:[UIImage imageWithData:user.profileImage]
            reviewText:review.reviewText
             wineColor:review.wine.color
             andRating:review.rating];
    
    // the content view covers the ReviewCell view so it neeeds to be hidden inorder for the ReviewCell view to record touches
    cell.contentView.hidden = YES;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Review *review = self.reviews[indexPath.row];
    
    [self.sizingCell setupClaimed:[review.claimedByUser boolValue] reviewWithUserName:nil userImage:nil reviewText:review.reviewText wineColor:nil andRating:nil];
    return self.sizingCell.bounds.size.height;
}



#pragma mark - ReviewCellDelegate

-(void)pushUserProfileVcForReviewerNumber:(NSInteger)reviewCellTag
{
    Review *review = self.reviews[reviewCellTag];
    User *user = review.user;
    UserProfileVC *userProfileTVC = [[UserProfileVC alloc] initWithUser:user];
    [self.navigationController pushViewController:userProfileTVC animated:YES];
}

-(void)pushUserReviewVcForReviewerNumber:(NSInteger)reviewCellTag
{
    Review *review = self.reviews[reviewCellTag];
    User *user = review.user;
    NSLog(@"push reviewVC for = %@",user.nameFull);
}




#pragma mark - Target action

- (IBAction)pushWineVC:(id)sender
{
    Wine_TRSICDTVC *wineCDTVC = [[Wine_TRSICDTVC alloc] initWithStyle:UITableViewStylePlain];
    
    // Pass the selected object to the new view controller.
    
    Review *review = (Review *)self.reviews[0];
    [wineCDTVC setupWithWine:review.wine fromRestaurant:review.tastingRecord.restaurant];
    
    [self.navigationController pushViewController:wineCDTVC animated:YES];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
