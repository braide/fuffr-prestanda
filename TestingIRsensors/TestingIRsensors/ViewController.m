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


- (IBAction)buttonPressed:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    
    if([title isEqualToString:@"Event per second"]){
        NSLog(@"Event per second");
    }else if([title isEqualToString:@"IR sensor range"]){
        NSLog(@"IR sensor range");
    }else if([title isEqualToString:@"Gesture recognition"]){
        NSLog(@"Gesture recognition");
    }else if([title isEqualToString:@"Multiple gest per side test"]){
        NSLog(@"Multiple gest per side test");
    }else if([title isEqualToString:@"Overload test"]){
        NSLog(@"Overload test");
    }else if([title isEqualToString:@"Accuracy during low battery"]){
        NSLog(@"Accuracy during low battery");
    }
    
    
}





@end
