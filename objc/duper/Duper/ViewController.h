//
//  ViewController.h
//  Duper
//
//  Created by Michael Wells on 1/22/15.
//  Copyright (c) 2015 jamfoundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *fullSizeImageView;
@property (nonatomic, weak) IBOutlet UILabel *fullSizeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *comparison1ImageView;
@property (nonatomic, weak) IBOutlet UILabel *comparison1Label;
@property (nonatomic, weak) IBOutlet UIImageView *comparison2ImageView;
@property (nonatomic, weak) IBOutlet UILabel *comparison2Label;
@property (nonatomic, weak) IBOutlet UIImageView *comparison3ImageView;
@property (nonatomic, weak) IBOutlet UILabel *comparison3Label;
@property (nonatomic, weak) IBOutlet UIImageView *comparison4ImageView;
@property (nonatomic, weak) IBOutlet UILabel *comparison4Label;

@end

