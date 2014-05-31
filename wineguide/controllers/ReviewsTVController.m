//
//  ReviewsTVController.m
//  Corkie
//
//  Created by Charles Feinn on 3/30/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ReviewsTVController.h"
#import "Review2.h"
#import "ReviewCell.h"
#import "User2.h"
#import "Wine2.h"
#import "WineNameVHTV.h"
#import "DateStringFormatter.h"
#import "ColorSchemer.h"
#import "UserProfileVC.h"
#import "Wine_TRSICDTVC.h"
#import "FacebookProfileImageGetter.h"

#define REVIEW_CELL @"ReviewCell"

@interface ReviewsTVController () <ReviewCellDelegate>

@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) ReviewCell *sizingCell;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WineNameVHTV *wineNameVHTV;
@property (nonatomic, strong) FacebookProfileImageGetter *facebookProfileImageGetter;

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

-(void)setupFromTastingRecord:(TastingRecord2 *)tastingRecord
{
    self.reviews = [tastingRecord.reviews sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"review_date" ascending:NO]]];
    
    self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ReviewsTVControllerHeaderView" owner:self options:nil] firstObject];
    self.tableView.tableHeaderView.backgroundColor = [ColorSchemer sharedInstance].customBackgroundColor;
    self.tableView.tableHeaderView.tintColor = [ColorSchemer sharedInstance].baseColor;
    
    Review2 *review = (Review2 *)self.reviews[0];
    self.dateLabel.attributedText = [DateStringFormatter attributedStringFromDate:tastingRecord.tasting_date];
    [self.wineNameVHTV setupTextViewWithWine:review.tastingRecord.wine fromRestaurant:tastingRecord.restaurant];
}


#pragma mark - Getters & setters

-(ReviewCell *)sizingCell
{
    if(!_sizingCell){
        _sizingCell = [self.tableView dequeueReusableCellWithIdentifier:REVIEW_CELL];
    }
    return _sizingCell;
}

-(FacebookProfileImageGetter *)facebookProfileImageGetter
{
    if(!_facebookProfileImageGetter){
        _facebookProfileImageGetter = [[FacebookProfileImageGetter alloc] init];
    }
    return _facebookProfileImageGetter;
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
    
    Review2 *review = self.reviews[indexPath.row];
    
    [cell setupWithReview:review forWineColorCode:review.tastingRecord.wine.color_code];
    [self loadUser:review.user imageInCell:cell atIndexPath:indexPath];
    
    cell.delegate = self;
    
    return cell;
}

-(void)loadUser:(User2 *)user imageInCell:(ReviewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(user.imageData){
        [cell.userImageButton setImage:[UIImage imageWithData:user.imageData] forState:UIControlStateNormal];
    } else {
        __weak UITableView *weakTableView = self.tableView;
        [self.facebookProfileImageGetter setProfilePicForUser:user inButton:cell.userImageButton completion:^(BOOL success) {
            if(success){
                if([weakTableView cellForRowAtIndexPath:indexPath]){
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }];
    }
}

#pragma mark - UITableViewDelegate


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Review2 *review = self.reviews[indexPath.row];
    
    [self.sizingCell setupWithReview:review forWineColorCode:nil];
    return self.sizingCell.bounds.size.height;
}



#pragma mark - ReviewCellDelegate

-(void)pushUserProfileVcForReviewerNumber:(NSInteger)reviewCellTag
{
    Review2 *review = self.reviews[reviewCellTag];
    User2 *user = review.user;
    UserProfileVC *userProfileTVC = [[UserProfileVC alloc] initWithUser:user];
    [self.navigationController pushViewController:userProfileTVC animated:YES];
}

-(void)pushUserReviewVcForReviewerNumber:(NSInteger)reviewCellTag
{
    Review2 *review = self.reviews[reviewCellTag];
    User2 *user = review.user;
    NSLog(@"push reviewVC for = %@",user.name_display);
}




#pragma mark - Target action

- (IBAction)pushWineVC:(id)sender
{
    Wine_TRSICDTVC *wineCDTVC = [[Wine_TRSICDTVC alloc] initWithStyle:UITableViewStylePlain];
    
    // Pass the selected object to the new view controller.
    
    Review2 *review = (Review2 *)self.reviews[0];
    [wineCDTVC setupWithWine:review.tastingRecord.wine fromRestaurant:review.tastingRecord.restaurant];
    
    [self.navigationController pushViewController:wineCDTVC animated:YES];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
