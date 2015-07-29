//
//  ViewController.m
//  Duper
//
//  Created by Michael Wells on 1/22/15.
//  Copyright (c) 2015 jamfoundry. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+PerspectiveHash.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage* image1 = [UIImage imageNamed:@"image1.jpg"];
    UIImage* image2 = [UIImage imageNamed:@"image1-enhanced.png"];
    UIImage* image3 = [UIImage imageNamed:@"image1-watermark.jpg"];
    UIImage* image4 = [UIImage imageNamed:@"image2.jpg"];
    UIImage* image5 = [UIImage imageNamed:@"image3.png"];
    
    [self.fullSizeImageView setImage:image1];
    [self.fullSizeLabel setText:@"Image #1"];
    
    [self.comparison1ImageView setImage:image2];
    [self.comparison1Label setText:@"Image #2"];
    
    [self.comparison2ImageView setImage:image3];
    [self.comparison2Label setText:@"Image #3"];
    
    [self.comparison3ImageView setImage:image4];
    [self.comparison3Label setText:@"Image #4"];
    
    [self.comparison4ImageView setImage:image5];
    [self.comparison4Label setText:@"Image #5"];
    
    unsigned long long hash1 = [image1 computePerspectiveHash];
    [self.fullSizeLabel setText:[NSString stringWithFormat:@"%qx", hash1]];
    
    unsigned long long hash2 = [image2 computePerspectiveHash];
    unsigned int diff1 = [UIImage comparePerspectiveHashes:hash1 hash2:hash2];
    [self.comparison1Label setText:[NSString stringWithFormat:@"%qx (%d)", hash2, diff1]];
    
    unsigned long long hash3 = [image3 computePerspectiveHash];
    unsigned int diff2 = [UIImage comparePerspectiveHashes:hash1 hash2:hash3];
    [self.comparison2Label setText:[NSString stringWithFormat:@"%qx (%d)", hash3, diff2]];
    
    unsigned long long hash4 = [image4 computePerspectiveHash];
    unsigned int diff3 = [UIImage comparePerspectiveHashes:hash1 hash2:hash4];
    [self.comparison3Label setText:[NSString stringWithFormat:@"%qx (%d)", hash4, diff3]];
    
    unsigned long long hash5 = [image5 computePerspectiveHash];
    unsigned int diff4 = [UIImage comparePerspectiveHashes:hash1 hash2:hash5];
    [self.comparison4Label setText:[NSString stringWithFormat:@"%qx (%d)", hash5, diff4]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
