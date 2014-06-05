//
//  AccuracyLowBatteryViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "AccuracyLowBatteryViewController.h"

@interface AccuracyLowBatteryViewController ()

@end

@implementation AccuracyLowBatteryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    [self setupGestureRecognizers];
}

-(void)setupFuffr{
    
    [[FFRTouchManager sharedManager]
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @1];
}

-(void)setupGestureRecognizers{
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    FFRTapGestureRecognizer* tap = [FFRTapGestureRecognizer new];
    tap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [tap addTarget: self action: @selector(onTap:)];
    [manager addGestureRecognizer: tap];
}

-(void)onTap:(id)sender{
    NSLog(@"tap");
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

@end
