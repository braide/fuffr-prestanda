//
//  OverloadViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "OverloadViewController.h"

@interface OverloadViewController ()
@property int numEventsRight;
@property double startTimeRight;
@property double startTimeLeft;
@property int numEventsLeft;
@property double startTimeTop;
@property int numEventsTop;
@property double startTimeBottom;
@property int numEventsBottom;
@end

@implementation OverloadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fuffrSetup];
    self.numEventsRight = 0;
    self.numEventsLeft = 0;
    self.numEventsTop = 0;
    self.numEventsBottom = 0;
}

- (void)fuffrSetup
{
    // Get a reference to the touch manager.
	FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
	// Set active sides.
    [[FFRTouchManager sharedManager]
     enableSides: FFRSideRight | FFRSideLeft | FFRSideBottom | FFRSideTop
     touchesPerSide: @5
     ];
	// Register methods for right side touches. The touchEnded
	// method is not used in this example.
    
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMovedRight:)
     touchEnded: @selector(touchesEndedRight:)
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMovedLeft:)
     touchEnded: @selector(touchesEndedLeft:)
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMovedBottom:)
     touchEnded: @selector(touchesEndedBottom:)
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMovedTop:)
     touchEnded: @selector(touchesEndedTop:)
     sides: FFRSideTop];
    
}

- (void) touchesMovedRight: (NSSet*)touches
{
    if (0 == self.numEventsRight) self.startTimeRight = CACurrentMediaTime();
    ++self.numEventsRight;
}

- (void) touchesEndedRight: (NSSet*)touches {
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = self.numEventsRight / (endTime - self.startTimeRight);
    NSLog(@"Events per second on right: %f", eventsPerSecond);
    self.numEventsRight = 0;
}

- (void) touchesMovedLeft: (NSSet*)touches
{
    if (0 == self.numEventsLeft) self.startTimeLeft = CACurrentMediaTime();
    ++self.numEventsLeft;
}

- (void) touchesEndedLeft: (NSSet*)touches {
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = self.numEventsLeft / (endTime - self.startTimeLeft);
    NSLog(@"Events per second on left: %f", eventsPerSecond);
    self.numEventsLeft = 0;
}

- (void)touchesMovedBottom: (NSSet*)touches{
    if (0 == self.numEventsBottom) self.startTimeBottom = CACurrentMediaTime();
    ++self.numEventsBottom;
}
- (void)touchesEndedBottom: (NSSet*)touches{
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = self.numEventsBottom / (endTime - self.startTimeBottom);
    NSLog(@"Events per second on bottom: %f", eventsPerSecond);
    self.numEventsBottom = 0;
}

- (void)touchesMovedTop: (NSSet *) touches {
    if (0 == self.numEventsTop) self.startTimeTop = CACurrentMediaTime();
    ++self.numEventsTop;
}

- (void)touchesEndedTop: (NSSet *) touches {
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = self.numEventsTop / (endTime - self.startTimeTop);
    NSLog(@"Events per second on top: %f", eventsPerSecond);
    self.numEventsTop = 0;
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
