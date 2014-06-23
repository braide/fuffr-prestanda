//
//  ViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import <FuffrLib/UIView+Toast.h>
#import "AppDelegate.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
}

-(void)viewDidAppear:(BOOL)animated{
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    [manager removeAllGestureRecognizers];
    [manager removeAllTouchObserversAndTouchBlocks];
    [manager enableSides:FFRSideRight touchesPerSide:@1];
}


-(void)setupFuffr{
    [self.view makeToast: @"Scanning for Fuffr"];
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    [manager
     onFuffrConnected:
     ^{
         NSLog(@"Fuffr Connected");
         [self.view makeToast: @"Fuffr Connected"];
         [manager useSensorService:
          ^{
              NSLog(@"Touch Sensors Ready");
              // Set active sides and number of touches per side.
              [[FFRTouchManager sharedManager]
               enableSides: FFRSideRight
               touchesPerSide: @1];
          }];
     }
     onFuffrDisconnected:
     ^{
         NSLog(@"Fuffr Disconnected");
         [self.view makeToast: @"Fuffr Disconnected"];
     }];
}

@end
