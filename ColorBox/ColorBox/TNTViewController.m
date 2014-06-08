//
//  TNTViewController.m
//  ColorBox
//
//  Created by Travis Thieman on 6/7/14.
//  Copyright (c) 2014 com.example. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "TNTView.h"
#import "TNTViewController.h"

@interface TNTViewController ()

@property CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet TNTView *myView;

@end

@implementation TNTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.motionManager = [[CMMotionManager alloc] init];
    if ([self.motionManager isDeviceMotionAvailable]) {
        if (![self.motionManager isDeviceMotionActive]) {
            [self.motionManager setDeviceMotionUpdateInterval:(1.0 / 30.0)];
            [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
                [self.myView updateColorsX:motion.gravity.x Y:motion.gravity.y Z:motion.gravity.z];
            }];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
