//
//  EventPerSecondViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "EventPerSecondViewController.h"
#import "EventsPerSecondSideModel.h"
#import <FuffrLib/UIView+Toast.h>

@interface EventPerSecondViewController ()

//UI
@property (weak, nonatomic) IBOutlet UISegmentedControl *topButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rightButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bottomButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *touchPerSecondLabel;

@property (strong, nonatomic) EventsPerSecondSideModel *rightSide, *leftSide, *topSide, *bottomSide;
@property (nonatomic) int tempCounter, numOfActiveTouches;
@property (nonatomic) float touchPerSecond, startTime, stopTime;
@property (strong, nonatomic) NSTimer *updateTouchPerSecondTimer;
@end

@implementation EventPerSecondViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.rightSide = [[EventsPerSecondSideModel alloc] init];
    self.leftSide = [[EventsPerSecondSideModel alloc] init];
    self.topSide = [[EventsPerSecondSideModel alloc] init];
    self.bottomSide = [[EventsPerSecondSideModel alloc] init];
    [self fuffrSetup];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receivedNotification:)
     name:@"Packets/Sec"
     object:nil];
}

// not used (for touch counter from lib)
- (void)receivedNotification:(NSNotification*)note
{
    self.tempCounter++;
    /*
    float c = [[[note userInfo] valueForKey:@"NumOfPackets"] floatValue];
    self.touchPerSecond = c;
     */
}

- (void)updateText
{
    float tempStop = CACurrentMediaTime();
    float eventsPerSecond = self.tempCounter / (tempStop - self.startTime);
    self.touchPerSecondLabel.text = [NSString stringWithFormat:@"Packets Per Second: %.2f", eventsPerSecond];
}

- (IBAction) changeSideOption:(UISegmentedControl *)sender
{
    if(sender == self.topButton)
    {
        if(sender.selectedSegmentIndex) self.topSide.sideEnabled = 0;
        else self.topSide.sideEnabled = FFRSideTop;
    }
    if(sender == self.rightButton)
    {
        if(sender.selectedSegmentIndex) self.rightSide.sideEnabled = 0;
        else self.rightSide.sideEnabled = FFRSideRight;
    }
    if(sender == self.bottomButton)
    {
        if(sender.selectedSegmentIndex) self.bottomSide.sideEnabled = 0;
        else self.bottomSide.sideEnabled = FFRSideBottom;
    }
    if(sender == self.leftButton)
    {
        if(sender.selectedSegmentIndex) self.leftSide.sideEnabled = 0;
        else self.leftSide.sideEnabled = FFRSideLeft;
    }
    [[FFRTouchManager sharedManager] enableSides: self.topSide.sideEnabled | self.bottomSide.sideEnabled | self.leftSide.sideEnabled | self.rightSide.sideEnabled touchesPerSide:@5];
}


- (void) fuffrSetup
{
    [self.view makeToast: @"Scanning for Fuffr"];
    // Get a reference to the touch manager.
	FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    
	// Set active sides.
    [[FFRTouchManager sharedManager]
     enableSides: 0
     touchesPerSide: @5
     ];
	// Register methods for right side touches. The touchEnded
	// method is not used in this example.
    
    [manager
     onFuffrConnected:
     ^{
         [manager useSensorService:
          ^{
              [[FFRTouchManager sharedManager] enableSides: self.topSide.sideEnabled | self.bottomSide.sideEnabled | self.leftSide.sideEnabled | self.rightSide.sideEnabled touchesPerSide:@5];
              [self.view makeToast: @"Fuffr Connected"];
          }];
     }
     onFuffrDisconnected:
     ^{
         [self.view makeToast: @"Fuffr Disconnected"];
     }];
    
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(fuffrTouchesBegan:)
     touchMoved: @selector(fuffrTouchesMoved:)
     touchEnded: @selector(fuffrTouchesEnded:)
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(fuffrTouchesBegan:)
     touchMoved: @selector(fuffrTouchesMoved:)
     touchEnded: @selector(fuffrTouchesEnded:)
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(fuffrTouchesBegan:)
     touchMoved: @selector(fuffrTouchesMoved:)
     touchEnded: @selector(fuffrTouchesEnded:)
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(fuffrTouchesBegan:)
     touchMoved: @selector(fuffrTouchesMoved:)
     touchEnded: @selector(fuffrTouchesEnded:)
     sides: FFRSideTop];
}

- (void) fuffrTouchesBegan:(NSSet*) touches
{
    self.numOfActiveTouches++;
    if (self.startTime==0)
    {
        self.startTime = CACurrentMediaTime();
        self.updateTouchPerSecondTimer = [NSTimer
                                          scheduledTimerWithTimeInterval:1
                                          target:self
                                          selector:@selector(updateText)
                                          userInfo:nil
                                          repeats:YES];
    }
}

- (void) fuffrTouchesMoved:(NSSet*) touches
{
}

- (void) fuffrTouchesEnded:(NSSet*) touches
{
    if (self.numOfActiveTouches > 0){
    self.numOfActiveTouches--;
    }
    self.stopTime = CACurrentMediaTime();
    if (self.numOfActiveTouches == 0){
        if (!((self.stopTime - self.startTime) < 0.01))
        {
            [self.updateTouchPerSecondTimer invalidate];
            self.updateTouchPerSecondTimer = nil;
            float packetsPerSecond = self.tempCounter / (self.stopTime - self.startTime);
            self.touchPerSecondLabel.text = [NSString stringWithFormat:@"Packets Per Second: %.2f", packetsPerSecond];
            self.tempCounter = 0;
            self.startTime = 0;
        }
    }
}
/*
- (void) touchesRightBegan: (NSSet*)touches
{
    [self fuffrTouchesBegan:touches withSideModel:self.rightSide];
}

- (void) touchesRightMoved: (NSSet*)touches
{
    [self fuffrTouchesMoved:touches withSideModel:self.rightSide];
}

- (void) touchesRightEnded: (NSSet*)touches
{
    [self fuffrTouchesEnded:touches withSideModel:self.rightSide outputLabel:self.rightLabel];
}

- (void) touchesLeftBegan: (NSSet*)touches
{
    [self fuffrTouchesBegan:touches withSideModel:self.leftSide];
}

- (void) touchesLeftMoved: (NSSet*)touches
{
    [self fuffrTouchesMoved:touches withSideModel:self.leftSide];
}

- (void) touchesLeftEnded: (NSSet*)touches
{
    [self fuffrTouchesEnded:touches withSideModel:self.leftSide outputLabel:self.leftLabel];
}

- (void) touchesTopBegan: (NSSet*)touches
{
    [self fuffrTouchesBegan:touches withSideModel:self.topSide];
}

- (void) touchesTopMoved: (NSSet*)touches
{
    [self fuffrTouchesMoved:touches withSideModel:self.topSide];
}

- (void) touchesTopEnded: (NSSet*)touches
{
    [self fuffrTouchesEnded:touches withSideModel:self.topSide outputLabel:self.topLabel];
}

- (void) touchesBottomBegan: (NSSet*)touches
{
    [self fuffrTouchesBegan:touches withSideModel:self.bottomSide];
}

- (void) touchesBottomMoved: (NSSet*)touches
{
    [self fuffrTouchesMoved:touches withSideModel:self.bottomSide];
}

- (void) touchesBottomEnded: (NSSet*)touches
{
    [self fuffrTouchesEnded:touches withSideModel:self.bottomSide outputLabel:self.bottomLabel];
}
*/

@end
