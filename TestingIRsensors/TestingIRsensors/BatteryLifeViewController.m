//
//  BatteryLifeViewController.m
//  TestingIRsensors
//
//  Created by Fuffr2 on 24/06/14.
//  Copyright (c) 2014 Fuffr2. All rights reserved.
//

#import "BatteryLifeViewController.h"
#import "BatteryLifeModel.h"
#import "AppDelegate.h"

@interface BatteryLifeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *topButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rightButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bottomButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *topSideLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSideLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftSideLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomSideLabel;

@property (nonatomic) int topSideEnabled, rightSideEnabled, bottomSideEnabled, leftSideEnabled;
@property (nonatomic) int topSidePreviousHighestNumOfTouches, rightSidePreviousHighestNumOfTouches, leftSidePreviousHighestNumOfTouches, bottomSidePreviousHighestNumOfTouches;
@property (strong, nonatomic) NSMutableArray *eventArray; //of BatteryLifeModel
@property (strong, nonatomic) NSDate *startStamp, *stopStamp;
@property (strong, nonatomic) NSTimer *timeOutTimer, *updateDurationLabelTimer;
@property (strong, nonatomic) AppDelegate *delegate;
@property (nonatomic) double duration;
@end

@implementation BatteryLifeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.eventArray = [[NSMutableArray alloc] init];
    self.delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [self fuffrSetup];
    [self fuffrAddObservers];
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

- (IBAction)startButtonPressed:(UIButton *)sender {
    //setup the stuff
    self.startStamp = [NSDate date];
    self.updateDurationLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    self.duration = 0;
    //sender.hidden = YES;
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
     onFuffrConnected:
     ^{
         [manager useSensorService:
          ^{
              [[FFRTouchManager sharedManager] enableSides: self.topSideEnabled | self.bottomSideEnabled | self.leftSideEnabled | self.rightSideEnabled touchesPerSide:@5];
              self.statusLabel.text = @"Fuffr Connected!";
              self.startStamp = [NSDate date];
              self.startStamp = [self.startStamp dateByAddingTimeInterval:-(self.duration)];
              if(self.timeOutTimer) {
                  [self.timeOutTimer invalidate];
                  self.timeOutTimer = nil;
                  self.updateDurationLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                                   target:self
                                                                                 selector:@selector(updateUI)
                                                                                 userInfo:nil
                                                                                  repeats:YES];
              }
              [[FFRTouchManager sharedManager] onFuffrDisconnected:^{[self fuffrDisconnected];}];
          }];
     }
     onFuffrDisconnected:
     ^{
         [self fuffrDisconnected];
     }];
}

- (void)fuffrAddObservers {
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesRightBegan:)
     touchMoved: nil
     touchEnded: @selector(touchesRightEnded:)
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesLeftBegan:)
     touchMoved: nil
     touchEnded: @selector(touchesLeftEnded:)
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBottomBegan:)
     touchMoved: nil
     touchEnded: @selector(touchesBottomEnded:)
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesTopBegan:)
     touchMoved: nil
     touchEnded: @selector(touchesTopEnded:)
     sides: FFRSideTop];
}

- (void)addEvent:(int)from to: (int) to onSide: (NSString *)side sideLabel:(UILabel *)label
{
    BatteryLifeModel *newEvent = [[BatteryLifeModel alloc] init];
    newEvent.timestamp = [NSDate date];
    newEvent.side = side;
    newEvent.previousNumOfActiveTouches = from;
    newEvent.currentNumOfActiveTouches = to;
    newEvent.info = [NSString stringWithFormat:@"from %d number of touches to %d number of touches on side %@", from, to, side];
    [self.eventArray addObject:newEvent];
    label.text = [NSString stringWithFormat:@"%d", to];
}

- (void)touchesLeftBegan: (NSSet*)touches
{
    [self addEvent:self.leftSidePreviousHighestNumOfTouches to:(self.leftSidePreviousHighestNumOfTouches+1) onSide:@"Left" sideLabel:self.leftSideLabel];
    self.leftSidePreviousHighestNumOfTouches++;
}

- (void)touchesLeftEnded: (NSSet*)touches
{
    [self addEvent:self.leftSidePreviousHighestNumOfTouches to:(self.leftSidePreviousHighestNumOfTouches-1) onSide:@"Left" sideLabel:self.leftSideLabel];
    self.leftSidePreviousHighestNumOfTouches--;
}

- (void)touchesRightBegan: (NSSet*)touches
{
    [self addEvent:self.rightSidePreviousHighestNumOfTouches to:(self.rightSidePreviousHighestNumOfTouches+1) onSide:@"Right" sideLabel:self.rightSideLabel];
    self.rightSidePreviousHighestNumOfTouches++;
}

- (void)touchesRightEnded: (NSSet*)touches
{
    [self addEvent:self.rightSidePreviousHighestNumOfTouches to:(self.rightSidePreviousHighestNumOfTouches-1) onSide:@"Right" sideLabel:self.rightSideLabel];
    self.rightSidePreviousHighestNumOfTouches--;
}

- (void)touchesTopBegan: (NSSet*)touches
{
    [self addEvent:self.topSidePreviousHighestNumOfTouches to:(self.topSidePreviousHighestNumOfTouches+1) onSide:@"Top" sideLabel:self.topSideLabel];
    self.topSidePreviousHighestNumOfTouches++;
}

- (void)touchesTopEnded: (NSSet*)touches
{
    [self addEvent:self.topSidePreviousHighestNumOfTouches to:(self.topSidePreviousHighestNumOfTouches-1) onSide:@"Top" sideLabel:self.topSideLabel];
    self.topSidePreviousHighestNumOfTouches--;
}

- (void)touchesBottomBegan: (NSSet*)touches
{
    [self addEvent:self.bottomSidePreviousHighestNumOfTouches to:(self.bottomSidePreviousHighestNumOfTouches+1) onSide:@"Bottom" sideLabel:self.bottomSideLabel];
    self.bottomSidePreviousHighestNumOfTouches++;
}

- (void)touchesBottomEnded: (NSSet*)touches
{
    [self addEvent:self.bottomSidePreviousHighestNumOfTouches to:(self.bottomSidePreviousHighestNumOfTouches-1) onSide:@"Bottom" sideLabel:self.bottomSideLabel];
    self.bottomSidePreviousHighestNumOfTouches--;
}

- (void)fuffrDisconnected
{
    self.stopStamp = [NSDate date];
    AudioServicesPlaySystemSound(1005);
    self.statusLabel.text = @"Fuffr Disconnected!";
    // wait and see if fuffr reconnects
    
    self.duration = [self.stopStamp timeIntervalSinceDate:self.startStamp];
    [self.updateDurationLabelTimer invalidate];
    self.timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
}

- (void)timeOut
{
    self.statusLabel.text = [NSString stringWithFormat:@"Test Complete!"];
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %.0f seconds", [self.stopStamp timeIntervalSinceDate:self.startStamp]];
    [self printEventArray];
}

- (void)updateUI
{
    NSDate *now = [NSDate date];
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %.0f seconds", [now timeIntervalSinceDate:self.startStamp]];
}

- (int)getNumOfEnabledSides {
    int numOfEnabledSides = 0;
    if (self.leftSideEnabled) numOfEnabledSides++;
    if (self.rightSideEnabled) numOfEnabledSides++;
    if (self.topSideEnabled) numOfEnabledSides++;
    if (self.bottomSideEnabled) numOfEnabledSides++;
    return numOfEnabledSides;
}

- (NSString *)getEnabledSides {
    NSString *temp = [NSString stringWithFormat:@""];
    if (self.leftSideEnabled)  temp = [temp stringByAppendingString:@"Left "];
    if (self.rightSideEnabled) temp = [temp stringByAppendingString:@"Right "];
    if (self.topSideEnabled) temp = [temp stringByAppendingString:@"Top "];
    if (self.bottomSideEnabled) temp = [temp stringByAppendingString:@"Bottom "];
    if ([temp length] > 1) temp = [temp substringToIndex:[temp length] - 1];
    return temp;
}

- (void)printEventArray {
    for (BatteryLifeModel *event in self.eventArray) {
        NSLog(@"%@",event.info);
    }
}

- (void)sendtoServer
{
    // prototype for the new servers DB and communication
    NSString *aHostName;
    if(self.delegate.serverIP) {
        aHostName = self.delegate.serverIP;
    }
    else {
        aHostName = @"192.168.1.151";
    }
    unsigned int aPort = 1337;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)aHostName, aPort, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    // add the information here
    [writeString appendString:[NSString stringWithFormat:@"%f, %d, %@, %d, \n",[self.stopStamp timeIntervalSinceDate:self.startStamp], [self getNumOfEnabledSides],[self getEnabledSides], (int)[self.eventArray count]]];
    for (BatteryLifeModel *event in self.eventArray) {
        [writeString appendString:[NSString stringWithFormat:@"%d, %d, %@, %@, \n", event.previousNumOfActiveTouches, event.currentNumOfActiveTouches, event.side,event.timestamp]];
    }

    /*
     DB template
     
     double duration;
     int NumOfEnabledSides;
     String enabledSides;
     one to many events
        event:
        int previousNumOfActiveTouches;
        int currentNumOfActiveTouches;
        string side;
        timestamp;
     */
    
    
	NSData *data = [[NSData alloc] initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
    
    [inputStream close];
    [outputStream close];

}

@end
