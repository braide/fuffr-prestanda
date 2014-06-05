//
//  OverloadViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "OverloadViewController.h"

@interface OverloadViewController ()
@property int counter;
@end

@implementation OverloadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    [self setupFFRTouch];
    self.counter = 0;
}

- (void)setupFuffr{
    
    [[FFRTouchManager sharedManager]
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @5];
}


- (void)setupFFRTouch {
    [[FFRTouchManager sharedManager] removeAllTouchObserversAndTouchBlocks];
    [[FFRTouchManager sharedManager] removeAllGestureRecognizers];
    [[FFRTouchManager sharedManager]
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesRight:)
     touchEnded: nil
     sides: FFRSideRight];
}

double startTime;
double duration = 5;

- (void) touchesRight: (NSSet*)touches
{
    if (0 == self.counter) startTime = CACurrentMediaTime();
    
    ++self.counter;
    
    double now = CACurrentMediaTime();
    if (startTime + duration <= now)
    {
        float eventsPerSecond = self.counter/duration;
        NSLog(@"Events per second: %f", eventsPerSecond);
        self.counter = 0;
    }
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
