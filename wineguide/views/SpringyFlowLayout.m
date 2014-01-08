//
//  SpringyFlowLayout.m
//  Gimme
//
//  Created by Charles Feinn on 12/12/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "SpringyFlowLayout.h"

#define SCROLL_RESISTANCE_COEFFICIENT .02

@interface SpringyFlowLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic) CGFloat latestDelta;

@end

@implementation SpringyFlowLayout

#pragma mark - Getters & Setters

-(UIDynamicAnimator *)dynamicAnimator
{
    if(!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return _dynamicAnimator;
}

-(NSMutableSet *)visibleIndexPathsSet
{
    if(!_visibleIndexPathsSet) _visibleIndexPathsSet = [[NSMutableSet alloc] init];
    return _visibleIndexPathsSet;
}

-(CGSize)collectionViewContentSize
{
    NSLog(@"contentSize height = %f",self.collectionView.contentSize.height);
    NSLog(@"contentSize width = %f",self.collectionView.contentSize.width);
    return CGSizeMake(250, 7000);
}

-(void)prepareLayout
{
    /*
    NSLog(@"self.collectionView.bounds.size.height = %f",self.collectionView.bounds.size.height);
    NSLog(@"self.collectionView.bounds.size.width = %f",self.collectionView.bounds.size.width);
    NSLog(@"self.collectionView.frame.size.height = %f",self.collectionView.frame.size.height);
    NSLog(@"self.collectionView.frame.size.width = %f",self.collectionView.frame.size.width);
    NSLog(@"contentSize height = %f",self.collectionView.contentSize.height);
    NSLog(@"contentSize = %f",self.collectionView.contentSize.width);
    NSLog(@"insets top = %f",self.sectionInset.top);
    NSLog(@"insets bottom = %f",self.sectionInset.bottom);
    NSLog(@"offset.x = %f",self.collectionView.contentOffset.x);
        NSLog(@"offset.y = %f",self.collectionView.contentOffset.y);
     */
    [super prepareLayout];
    
    CGRect originalRect = CGRectMake(self.collectionView.bounds.origin.x, self.collectionView.bounds.origin.x, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    NSLog(@"originalRect height = %f",originalRect.size.height);
    NSLog(@"originalRect width = %f",originalRect.size.width);
    CGRect visibleRect = CGRectInset(originalRect, 0, -500);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    NSLog(@"itemsInVisibleRectArray count = %i",[itemsInVisibleRectArray count]);
    
    for(UICollectionViewLayoutAttributes *item in itemsInVisibleRectArray){
        NSLog(@"item height = %f",item.frame.size.height);
        NSLog(@"item width = %f",item.frame.size.width);
    }
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    NSPredicate *noLongerVisiblePredicate = [NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behavior, NSDictionary *bindings) {
        
        // if member: returns nil the items is no longer visible and the predicate will return true
        BOOL notVisible = [itemsIndexPathsInVisibleRectSet member:[[behavior.items firstObject] indexPath]] == nil;
        return notVisible;
    }];
    
    // filteredArrayUsingPredicate: returns an array of obj for which the predicate is true
    NSArray *noLongerVisibleBehaviors = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:noLongerVisiblePredicate];
    
    for(UIAttachmentBehavior *behavior in noLongerVisibleBehaviors){
        [self.dynamicAnimator removeBehavior:behavior];
        [self.visibleIndexPathsSet removeObject:[[behavior.items firstObject] indexPath]];
    }
    
    // predicate to determine NEWLY visible items (those that aren't yet in self.visibleIndexPathsSet
    NSPredicate *areNewlyVisiblePredicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL notInVisibleIndexPathsSet = [self.visibleIndexPathsSet member:item.indexPath] == nil;
        return notInVisibleIndexPathsSet;
    }];
    
    // items that need behaviors
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:areNewlyVisiblePredicate];
    
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        spring.length = 0.0;
        spring.damping = 0.5;
        spring.frequency = 0.8;
        
        if(!CGPointEqualToPoint(CGPointZero, touchLocation)){
            CGFloat scrollDelta = fabsf(touchLocation.y - spring.anchorPoint.y);
            [self addBehavior:spring forTouchLocation:touchLocation andScrollDelta:scrollDelta];
        }
        [self.dynamicAnimator addBehavior:spring];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    // the user's touch point on the screen
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    UICollectionViewLayoutAttributes *item;
    for(UIAttachmentBehavior *spring in self.dynamicAnimator.behaviors){
        item = [self addBehavior:spring forTouchLocation:touchLocation andScrollDelta:scrollDelta];
    }
    [self.dynamicAnimator updateItemUsingCurrentState:item];
    
    return NO;
}

-(UICollectionViewLayoutAttributes *)addBehavior:(UIAttachmentBehavior *)behavior forTouchLocation:(CGPoint)touchLocation andScrollDelta:(CGFloat)scrollDelta
{
    CGPoint anchorPoint = behavior.anchorPoint;
    CGFloat distanceFromTouch = fabsf(anchorPoint.y - touchLocation.y);
    
    CGFloat scrollResistance = distanceFromTouch * SCROLL_RESISTANCE_COEFFICIENT;
    
    UICollectionViewLayoutAttributes *item = [behavior.items firstObject];
    CGPoint center = item.center;
    
    // if the scrollResistance was larger than the scrollDelta the cell would move in the opposite direction of the users finger
    
    if(self.latestDelta < 0){
        center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
    } else {
        center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
    }
    item.center = center;
    
    self.latestDelta = scrollDelta;
    
    return item;
}





@end
