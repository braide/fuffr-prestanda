//
//  BatteryLifeViewController.m
//  TestingIRsensors
//
//  Created by Fuffr2 on 24/06/14.
//  Copyright (c) 2014 Fuffr2. All rights reserved.
//

#import "BatteryLifeViewController.h"

@interface BatteryLifeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *topButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rightButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bottomButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *leftButton;

@property (nonatomic) int topSideEnabled, rightSideEnabled, bottomSideEnabled, leftSideEnabled;
@end

@implementation BatteryLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fuffrSetup];
}

- (IBAction)changeSideOption:(UISegmentedControl *)sender {
    if(sender == self.topButton) {
        if(sender.selectedSegmentIndex) self.topSideEnabled = 0;
        else self.topSideEnabled = FFRSideTop;
    }
    if(sender == self.rightButton) {
        if(sender.selectedSegmentIndex) self.rightSideEnabled = 0;
        else self.rightSideEnabled = FFRSideRight;
    }
    if(sender == self.bottomButton) {
        if(sender.selectedSegmentIndex) self.bottomSideEnabled = 0;
        else self.bottomSideEnabled = FFRSideBottom;
    }
    if(sender == self.leftButton) {
        if(sender.selectedSegmentIndex) self.leftSideEnabled = 0;
        else self.leftSideEnabled = FFRSideLeft;
    }
    [[FFRTouchManager sharedManager] enableSides: self.topSideEnabled | self.bottomSideEnabled | self.leftSideEnabled | self.rightSideEnabled touchesPerSide:@5];
}

- (void)fuffrSetup
{
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
     addTouchObserver: self
     touchBegan: @selector(touchesRight:)
     touchMoved: @selector(touchesRight:)
     touchEnded: @selector(touchesRight:)
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesLeft:)
     touchMoved: @selector(touchesLeft:)
     touchEnded: @selector(touchesLeft:)
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBottom:)
     touchMoved: @selector(touchesBottom:)
     touchEnded: @selector(touchesBottom:)
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesTop:)
     touchMoved: @selector(touchesTop:)
     touchEnded: @selector(touchesTop:)
     sides: FFRSideTop];
}

- (void) touchesLeft: (NSSet*)touches
{
}

- (void) touchesRight: (NSSet*)touches
{
}

- (void) touchesTop: (NSSet*)touches
{
}

- (void) touchesBottom: (NSSet*)touches
{
}

@end
