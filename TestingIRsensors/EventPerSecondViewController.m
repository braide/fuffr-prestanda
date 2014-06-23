//
//  EventPerSecondViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "EventPerSecondViewController.h"
#import "EventsPerSecondStorageModel.h"
#import "EventsPerSecondSideModel.h"
#import "AppDelegate.h"

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
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;
@property (weak, nonatomic) IBOutlet UIButton *topActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *rightActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *leftActiveButton;

@property (strong, nonatomic) NSMutableArray *eventsPerSecondArray; // of eventsPerSecondStorageModel
@property (strong, nonatomic) NSMutableArray *activeSidesArray; // of NSString
@property (strong, nonatomic) EventsPerSecondSideModel *rightSide, *leftSide, *topSide, *bottomSide;
@property (nonatomic) int eventId, numOfSidesActiveAtOnce, numOfTouchesActive, eventIdCounter;
@property (strong, nonatomic) AppDelegate *delegate;
@property (nonatomic) double testDuration;
@end

@implementation EventPerSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rightSide = [[EventsPerSecondSideModel alloc] init];
    self.leftSide = [[EventsPerSecondSideModel alloc] init];
    self.topSide = [[EventsPerSecondSideModel alloc] init];
    self.bottomSide = [[EventsPerSecondSideModel alloc] init];
    [self fuffrSetup];
    self.eventsPerSecondArray = [[NSMutableArray alloc] init];
    self.activeSidesArray = [[NSMutableArray alloc] init];
    self.delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [self.durationTextField setDelegate:self];
    self.numOfTouchesActive = 1;
    self.eventIdCounter = 1;
}


- (IBAction)changeSideOption:(UISegmentedControl *)sender {
    if(sender == self.topButton) {
        if(sender.selectedSegmentIndex) self.topSide.sideEnabled = 0;
        else self.topSide.sideEnabled = FFRSideTop;
    }
    if(sender == self.rightButton) {
        if(sender.selectedSegmentIndex) self.rightSide.sideEnabled = 0;
        else self.rightSide.sideEnabled = FFRSideRight;
    }
    if(sender == self.bottomButton) {
        if(sender.selectedSegmentIndex) self.bottomSide.sideEnabled = 0;
        else self.bottomSide.sideEnabled = FFRSideBottom;
    }
    if(sender == self.leftButton) {
        if(sender.selectedSegmentIndex) self.leftSide.sideEnabled = 0;
        else self.leftSide.sideEnabled = FFRSideLeft;
    }
    [[FFRTouchManager sharedManager] enableSides: self.topSide.sideEnabled | self.bottomSide.sideEnabled | self.leftSide.sideEnabled | self.rightSide.sideEnabled touchesPerSide:@5];
}

- (IBAction)durationTextFieldChanged:(UITextField *)sender {
    self.testDuration = [sender.text doubleValue];
    NSLog(@"duration = %f",self.testDuration);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.durationTextField resignFirstResponder];
    return YES;
}

- (IBAction)numOfActiveTouchesButtonPressed:(UIButton *)sender {
    int labelValue = [sender.currentTitle intValue];
    labelValue++;
    if (labelValue > 5) labelValue = 1;
    [sender setTitle:[NSString stringWithFormat:@"%d",labelValue] forState:UIControlStateNormal];
    self.numOfTouchesActive = labelValue;
}

- (IBAction)activeButtonPressed:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"Active"]) {
        [sender setTitle:@"Inactive" forState:UIControlStateNormal];
        if (sender == self.topActiveButton) {
            [self.activeSidesArray removeObject:@"Top"];
        }
        if (sender == self.rightActiveButton) {
            [self.activeSidesArray removeObject:@"Right"];
        }
        if (sender == self.leftActiveButton) {
            [self.activeSidesArray removeObject:@"Left"];
        }
        if (sender == self.bottomActiveButton) {
            [self.activeSidesArray removeObject:@"Bottom"];
        }
        
    }
    else {
        [sender setTitle:@"Active" forState:UIControlStateNormal];
        if (sender == self.topActiveButton) {
            [self.activeSidesArray addObject:@"Top"];
        }
        if (sender == self.rightActiveButton) {
            [self.activeSidesArray addObject:@"Right"];
        }
        if (sender == self.leftActiveButton) {
            [self.activeSidesArray addObject:@"Left"];
        }
        if (sender == self.bottomActiveButton) {
            [self.activeSidesArray addObject:@"Bottom"];
        }
    }
}

- (IBAction)resetTimerButtonPressed:(UIButton *)sender {
    self.leftSide.numOfEvents = 0;
    self.rightSide.numOfEvents = 0;
    self.bottomSide.numOfEvents = 0;
    self.topSide.numOfEvents = 0;
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

- (void)touchesCounter: (NSSet *)touches withSideModel: (EventsPerSecondSideModel *) sideModel onSide: (NSString *) side label: (UILabel *) label {
    if (sideModel.numOfEvents==0) sideModel.startTime = CACurrentMediaTime();
    ++sideModel.numOfEvents;
    //NSLog(@"%d",sideModel.numOfEvents);
    if (CACurrentMediaTime() >= sideModel.startTime + self.testDuration) {
        sideModel.stopTime = CACurrentMediaTime();
        float eventsPerSecond = sideModel.numOfEvents / (sideModel.stopTime - sideModel.startTime);
        NSLog(@"EPS id %d on %@: %f with duration: %f",self.eventId ,side,eventsPerSecond,(sideModel.stopTime - sideModel.startTime));
        label.text =[NSString stringWithFormat:@"%f", eventsPerSecond];
        
        //storagemodel code
        EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
        eps.eventId = self.eventId;
        if (self.eventIdCounter == [self.activeSidesArray count]) {
            self.eventId++;
            self.eventIdCounter = 0;
        }
        eps.eventsPerSecond = eventsPerSecond;
        eps.side = side;
        eps.numOfEnabledSides = [self getNumOfEnabledSides];
        eps.enabledSides = [self getEnabledSides];
        eps.numOfSidesActiveAtOnce = (int)[self.activeSidesArray count];
        eps.sidesActiveAtOnce = [self getActiveSides];
        eps.numOfTouchesActiveAtOnce = self.numOfTouchesActive;
        eps.durationInSeconds = (sideModel.stopTime - sideModel.startTime);
        [self.eventsPerSecondArray addObject:eps];
        
        
        self.eventIdCounter++;
        sideModel.numOfEvents = 0;
    }
}

- (void) touchesLeft: (NSSet*)touches
{
    [self touchesCounter:touches withSideModel:self.leftSide onSide:@"Left" label:self.leftLabel];
}

- (void) touchesRight: (NSSet*)touches
{
    [self touchesCounter:touches withSideModel:self.rightSide onSide:@"Right" label:self.rightLabel];
}

- (void) touchesTop: (NSSet*)touches
{
    [self touchesCounter:touches withSideModel:self.topSide onSide:@"Top" label:self.topLabel];
}

- (void) touchesBottom: (NSSet*)touches
{
    [self touchesCounter:touches withSideModel:self.bottomSide onSide:@"Bottom" label:self.bottomLabel];
}

- (IBAction)sendToServerPressed:(UIButton *)sender {
    //[self printStorageModel];
    [self sendFileToServer];
}

// currently not used. Saving array locally
- (void)saveArrayToFile: (NSString *) fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]) {
        [[NSFileManager defaultManager] createFileAtPath:dataFilePath contents:nil attributes:nil];
    }
    
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    
    for (int i=0; i<[self.eventsPerSecondArray count]; i++) {
        EventsPerSecondStorageModel *eps = [self.eventsPerSecondArray objectAtIndex:i];
        [writeString appendString:[NSString stringWithFormat:@"%d, %f, %@, %d, %@, %d, %@, %d, %f, \n", eps.eventId, eps.eventsPerSecond, eps.side, eps.numOfEnabledSides, eps.enabledSides, eps.numOfSidesActiveAtOnce, eps.sidesActiveAtOnce, eps.numOfTouchesActiveAtOnce, eps.durationInSeconds]];
    }
    NSLog(@"writeString :%@",writeString);
    
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: dataFilePath];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)sendFileToServer {
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
    if (self.delegate.accuracyEnviromentOn) {
        for (int i=0; i<[self.eventsPerSecondArray count]; i++) {
            EventsPerSecondStorageModel *eps = [self.eventsPerSecondArray objectAtIndex:i];
            [writeString appendString:[NSString stringWithFormat:@"%d, %f, %@, %d, %@, %d, %@, %d, %f, %@, %@, \n", eps.eventId, eps.eventsPerSecond, eps.side, eps.numOfEnabledSides, eps.enabledSides, eps.numOfSidesActiveAtOnce, eps.sidesActiveAtOnce, eps.numOfTouchesActiveAtOnce, eps.durationInSeconds, self.delegate.brightness, self.delegate.surface]];
        }
    }
    else {
        for (int i=0; i<[self.eventsPerSecondArray count]; i++) {
            EventsPerSecondStorageModel *eps = [self.eventsPerSecondArray objectAtIndex:i];
            [writeString appendString:[NSString stringWithFormat:@"%d, %f, %@, %d, %@, %d, %@, %d, %f, \n", eps.eventId, eps.eventsPerSecond, eps.side, eps.numOfEnabledSides, eps.enabledSides, eps.numOfSidesActiveAtOnce, eps.sidesActiveAtOnce, eps.numOfTouchesActiveAtOnce, eps.durationInSeconds]];
        }
    }
	NSData *data = [[NSData alloc] initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
    
    [inputStream close];
    [outputStream close];
}

- (NSString *)getEnabledSides {
    NSString *temp = [NSString stringWithFormat:@""];
    if (self.leftSide.sideEnabled)  temp = [temp stringByAppendingString:@"Left "];
    if (self.rightSide.sideEnabled) temp = [temp stringByAppendingString:@"Right "];
    if (self.topSide.sideEnabled) temp = [temp stringByAppendingString:@"Top "];
    if (self.bottomSide.sideEnabled) temp = [temp stringByAppendingString:@"Bottom "];
    if ([temp length] > 1) temp = [temp substringToIndex:[temp length] - 1];
    return temp;
}

- (NSString *)getActiveSides {
    NSString *temp = [NSString stringWithFormat:@""];
    if ([self.activeSidesArray containsObject:@"Left"])  temp = [temp stringByAppendingString:@"Left "];
    if ([self.activeSidesArray containsObject:@"Right"]) temp = [temp stringByAppendingString:@"Right "];
    if ([self.activeSidesArray containsObject:@"Top"]) temp = [temp stringByAppendingString:@"Top "];
    if ([self.activeSidesArray containsObject:@"Bottom"]) temp = [temp stringByAppendingString:@"Bottom "];
    if ([temp length] > 1) temp = [temp substringToIndex:[temp length] - 1];
    return temp;
}

- (void)printStorageModel {
    for (EventsPerSecondStorageModel *eps in self.eventsPerSecondArray) {
        NSLog(@"id = %d", eps.eventId);
        NSLog(@"EPS = %f", eps.eventsPerSecond);
        NSLog(@"side = %@", eps.side);
        NSLog(@"numOfEnabledSides = %d", eps.numOfEnabledSides);
        NSLog(@"enabledSides = %@", eps.enabledSides);
        NSLog(@"numOfSidesActiveAtOnce = %d", eps.numOfSidesActiveAtOnce);
        NSLog(@"sidesActiveAtOnce = %@", eps.sidesActiveAtOnce);
        NSLog(@"numOfTouchesActiveAtOnce = %d", eps.numOfTouchesActiveAtOnce);
        NSLog(@"durationInSeconds = %f", eps.durationInSeconds);
    }
}

- (int)getNumOfEnabledSides {
    int numOfEnabledSides = 0;
    if (self.leftSide.sideEnabled) numOfEnabledSides++;
    if (self.rightSide.sideEnabled) numOfEnabledSides++;
    if (self.topSide.sideEnabled) numOfEnabledSides++;
    if (self.bottomSide.sideEnabled) numOfEnabledSides++;
    return numOfEnabledSides;
}



@end
