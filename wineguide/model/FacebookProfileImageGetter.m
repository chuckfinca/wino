//
//  FacebookProfileImageGetter.m
//  Corkie
//
//  Created by Charles Feinn on 5/3/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FacebookProfileImageGetter.h"
#import <UIImageView+AFNetworking.h>
#import <UIButton+AFNetworking.h>

@interface FacebookProfileImageGetter ()

@property (nonatomic, strong) UIImage *placeHolderImage;

@end

@implementation FacebookProfileImageGetter

-(UIImage *)placeHolderImage
{
    if(!_placeHolderImage){
        _placeHolderImage = [[UIImage imageNamed:@"user_default.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    return _placeHolderImage;
}

-(void)setProfilePicForUser:(User *)user inImageView:(UIImageView *)imageView completion:(void (^)(BOOL success))completion
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", user.identifier]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:URL];
    [imageView setImageWithURLRequest:urlRequest placeholderImage:self.placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        user.profileImage = UIImagePNGRepresentation(image);
        completion(YES);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // NSLog(@"failed to download profile image\nrequest = %@\nresponse = %@\nerror = %@",request,response,error.localizedDescription);
    }];
}

-(void)setProfilePicForUser:(User *)user inButton:(UIButton *)button completion:(void (^)(BOOL success))completion
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", user.identifier]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:URL];
    
    [button setImageForState:UIControlStateNormal withURLRequest:urlRequest placeholderImage:self.placeHolderImage success:^(NSHTTPURLResponse *response, UIImage *image) {
        user.profileImage = UIImagePNGRepresentation(image);
        completion(YES);
    } failure:^(NSError *error) {
        
        // NSLog(@"failed to download profile image\nerror = %@",error.localizedDescription);
    }];
}















@end
