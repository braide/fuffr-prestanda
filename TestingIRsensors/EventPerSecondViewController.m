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

@property (strong, nonatomic) NSMutableArray *eventsPerSecondArray; // of eventsPerSecondStorageModel
@property (strong, nonatomic) EventsPerSecondSideModel *rightSide, *leftSide, *topSide, *bottomSide;
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
     touchBegan: @selector(touchesBeganRight:)
     touchMoved: @selector(touchesMovedRight:)
     touchEnded: @selector(touchesEndedRight:)
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganLeft:)
     touchMoved: @selector(touchesMovedLeft:)
     touchEnded: @selector(touchesEndedLeft:)
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganBottom:)
     touchMoved: @selector(touchesMovedBottom:)
     touchEnded: @selector(touchesEndedBottom:)
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: @selector(touchesBeganTop:)
     touchMoved: @selector(touchesMovedTop:)
     touchEnded: @selector(touchesEndedTop:)
     sides: FFRSideTop];
}

- (void) touchesBeganRight: (NSSet *)touches {
    self.rightSide.numOfActiveTouches++;
    self.rightSide.startTime = CACurrentMediaTime();
    self.rightSide.numOfEvents = 1;
}

- (void) touchesMovedRight: (NSSet*)touches
{
    self.rightSide.numOfEvents++;
}

- (void) touchesEndedRight: (NSSet*)touches {
    self.rightSide.numOfEvents++;
    self.rightSide.numOfActiveTouches--;
    if (!self.rightSide.numOfActiveTouches) {
        //TODO: CONTINUE
        self.rightSide.stopTime = CACurrentMediaTime();
        float eventsPerSecond = self.rightSide.numOfEvents / (self.rightSide.stopTime - self.rightSide.startTime);
        NSLog(@"Events per second on right: %f", eventsPerSecond);
        self.rightLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
        //storagemodel code here
        EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
        eps.eventsPerSecond = eventsPerSecond;
        eps.side = @"Right";
        [self.eventsPerSecondArray addObject:eps];
        self.rightSide.numOfEvents = 0;
    }
}

/*
 @property (nonatomic) float eventsPerSecond;
 @property (nonatomic, strong) NSString *side;
 @property (nonatomic) int numOfEnabledSides;
 @property (nonatomic, strong) NSString *enabledSides;
 @property (nonatomic) int numOfSidesActiveAtOnce;
 @property (nonatomic, strong) NSString *sidesActiveAtOnce;
 @property (nonatomic) int numOfTouchesActiveAtOnce;
 @property (nonatomic) float durationInSeconds;
 */
- (void) touchesBeganLeft: (NSSet*)touches
{
    self.leftSide.numOfActiveTouches++;
    self.leftSide.startTime = CACurrentMediaTime();
    self.leftSide.numOfEvents = 1;
}

- (void) touchesMovedLeft: (NSSet*)touches
{
    self.leftSide.numOfEvents++;
}

- (void) touchesEndedLeft: (NSSet*)touches {
    self.leftSide.numOfEvents++;
    self.leftSide.numOfActiveTouches--;
    if (!self.leftSide.numOfActiveTouches) {
        self.leftSide.stopTime = CACurrentMediaTime();
        float eventsPerSecond = self.leftSide.numOfEvents / (self.leftSide.stopTime - self.leftSide.startTime);
        NSLog(@"Events per second on left: %f", eventsPerSecond);
        self.leftLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
        //storagemodel code here
        EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
        eps.eventsPerSecond = eventsPerSecond;
        eps.side = @"Left";
        [self.eventsPerSecondArray addObject:eps];
        self.leftSide.numOfEvents = 0;
        
    }
}

- (void) touchesBeganBottom: (NSSet*)touches
{
    self.bottomSide.numOfActiveTouches++;
    self.bottomSide.startTime = CACurrentMediaTime();
    self.bottomSide.numOfEvents = 1;
}

- (void)touchesMovedBottom: (NSSet*)touches{
    self.bottomSide.numOfEvents++;
}
- (void)touchesEndedBottom: (NSSet*)touches{
    self.bottomSide.numOfEvents++;
    self.bottomSide.numOfActiveTouches--;
    if (!self.bottomSide.numOfActiveTouches) {
        self.bottomSide.stopTime = CACurrentMediaTime();
        float eventsPerSecond = self.bottomSide.numOfEvents / (self.bottomSide.stopTime - self.bottomSide.startTime);
        NSLog(@"Events per second on bottom: %f", eventsPerSecond);
        self.bottomLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
        //storagemodel code here
        EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
        eps.eventsPerSecond = eventsPerSecond;
        eps.side = @"Bottom";
        [self.eventsPerSecondArray addObject:eps];
        self.bottomSide.numOfEvents = 0;
    }
}

- (void) touchesBeganTop: (NSSet*)touches
{
    self.topSide.numOfActiveTouches++;
    self.topSide.startTime = CACurrentMediaTime();
    self.topSide.numOfEvents = 1;
}

- (void)touchesMovedTop: (NSSet *) touches {
    self.topSide.numOfEvents++;
}

- (void)touchesEndedTop: (NSSet *) touches {
    self.topSide.numOfEvents++;
    self.topSide.numOfActiveTouches--;
    if (!self.topSide.numOfActiveTouches) {
        self.topSide.stopTime = CACurrentMediaTime();
        float eventsPerSecond = self.topSide.numOfEvents / (self.topSide.stopTime - self.topSide.startTime);
        NSLog(@"Events per second on top: %f", eventsPerSecond);
        self.topLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
        //storagemodel code here
        EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
        eps.eventsPerSecond = eventsPerSecond;
        eps.side = @"Top";
        [self.eventsPerSecondArray addObject:eps];
        self.topSide.numOfEvents = 0;
    }
}

- (IBAction)sendToServerPressed:(UIButton *)sender {
    //[self saveArrayToFile:@"test.csv"];
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
        [writeString appendString:[NSString stringWithFormat:@"%f, %@, \n", eps.eventsPerSecond, eps.side]];
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
    NSString *aHostName = @"192.168.1.133";
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
    
    // send a test string
    //NSString *response  = [NSString stringWithFormat:@"I am BATMAN!"];
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<[self.eventsPerSecondArray count]; i++) {
        EventsPerSecondStorageModel *eps = [self.eventsPerSecondArray objectAtIndex:i];
        [writeString appendString:[NSString stringWithFormat:@"%f, %@, \n", eps.eventsPerSecond, eps.side]];
    }
    NSLog(@"WriteString: %@", writeString);
	NSData *data = [[NSData alloc] initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
}

- (NSString *)getEnabledSides {
    NSString *temp = [NSString stringWithFormat:@""];
    if (self.leftSide.sideEnabled)  temp = [temp stringByAppendingString:@"left,"];
    if (self.rightSide.sideEnabled) temp = [temp stringByAppendingString:@"right,"];
    if (self.topSide.sideEnabled) temp = [temp stringByAppendingString:@"top,"];
    if (self.bottomSide.sideEnabled) temp = [temp stringByAppendingString:@"bottom"];
    return temp;
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
