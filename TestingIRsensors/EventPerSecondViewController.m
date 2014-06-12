//
//  EventPerSecondViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 31/05/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "EventPerSecondViewController.h"
#import "EventsPerSecondStorageModel.h"

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
@property (nonatomic) int numOfEnabledTouchesPerSide;
@end

@implementation EventPerSecondViewController
int topSide, rightSide, leftSide, bottomSide;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numOfEnabledTouchesPerSide = 1;
    [self fuffrSetup];
    self.eventsPerSecondArray = [[NSMutableArray alloc] init];
}


- (IBAction)changeSideOption:(UISegmentedControl *)sender {
    if(sender == self.topButton) {
        if(sender.selectedSegmentIndex) topSide = 0;
        else topSide = FFRSideTop;
    }
    if(sender == self.rightButton) {
        if(sender.selectedSegmentIndex) rightSide = 0;
        else rightSide = FFRSideRight;
    }
    if(sender == self.bottomButton) {
        if(sender.selectedSegmentIndex) bottomSide = 0;
        else bottomSide = FFRSideBottom;
    }
    if(sender == self.leftButton) {
        if(sender.selectedSegmentIndex) leftSide = 0;
        else leftSide = FFRSideLeft;
    }
    [[FFRTouchManager sharedManager] enableSides: topSide | bottomSide | leftSide | rightSide touchesPerSide:[NSNumber numberWithInt:self.numOfEnabledTouchesPerSide]];
}

- (void)fuffrSetup
{
    // Get a reference to the touch manager.
	FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
	// Set active sides.
    [[FFRTouchManager sharedManager]
     enableSides: 0
     touchesPerSide: [NSNumber numberWithInt:self.numOfEnabledTouchesPerSide]
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
    /*
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMoved:)
     touchEnded: @selector(touchesEnded:)
     sides: FFRSideRight];
    
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMoved:)
     touchEnded: @selector(touchesEnded:)
     sides: FFRSideLeft];
    
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMoved:)
     touchEnded: @selector(touchesEnded:)
     sides: FFRSideBottom];
    
    [manager
     addTouchObserver: self
     touchBegan: nil
     touchMoved: @selector(touchesMoved:)
     touchEnded: @selector(touchesEnded:)
     sides: FFRSideTop];
     */
}

double startTimeRight;
int numEventsRight = 0;

- (void) touchesMoved: (NSSet *) touches {
    
}

- (void) touchesEnded: (NSSet *) touches {
    
}

- (void) touchesBeganRight: (NSSet *)touches {
    startTimeRight = CACurrentMediaTime();
    ++numEventsRight;
}

- (void) touchesMovedRight: (NSSet*)touches
{
    ++numEventsRight;
}

- (void) touchesEndedRight: (NSSet*)touches {
    ++numEventsRight;
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = numEventsRight / (endTime - startTimeRight);
    self.rightLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
    NSLog(@"Events per second on right: %f", eventsPerSecond);
    EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
    eps.eventsPerSecond = eventsPerSecond;
    eps.side = @"Right";
    [self.eventsPerSecondArray addObject:eps];
    numEventsRight = 0;
}

double startTimeLeft;
int numEventsLeft = 0;

- (void) touchesMovedLeft: (NSSet*)touches
{
    if (0 == numEventsLeft) startTimeLeft = CACurrentMediaTime();
    ++numEventsLeft;
}

- (void) touchesEndedLeft: (NSSet*)touches {
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = numEventsLeft / (endTime - startTimeLeft);
    self.leftLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
    NSLog(@"Events per second on left: %f", eventsPerSecond);
    EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
    eps.eventsPerSecond = eventsPerSecond;
    eps.side = @"Left";
    [self.eventsPerSecondArray addObject:eps];
    numEventsLeft = 0;
}


double startTimeBottom;
int numEventsBottom;
- (void)touchesMovedBottom: (NSSet*)touches{
    if (0 == numEventsBottom) startTimeBottom = CACurrentMediaTime();
    ++numEventsBottom;
}
- (void)touchesEndedBottom: (NSSet*)touches{
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = numEventsBottom / (endTime - startTimeBottom);
    self.bottomLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
    NSLog(@"Events per second on bottom: %f", eventsPerSecond);
    EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
    eps.eventsPerSecond = eventsPerSecond;
    eps.side = @"Bottom";
    [self.eventsPerSecondArray addObject:eps];
    numEventsBottom = 0;
}

double startTimeTop;
int numEventsTop;
- (void)touchesMovedTop: (NSSet *) touches {
    if (0 == numEventsTop) startTimeTop = CACurrentMediaTime();
    ++numEventsTop;
}

- (void)touchesEndedTop: (NSSet *) touches {
    double endTime = CACurrentMediaTime();
    float eventsPerSecond = numEventsTop / (endTime - startTimeTop);
    self.topLabel.text = [NSString stringWithFormat:@"%f", eventsPerSecond];
    NSLog(@"Events per second on top: %f", eventsPerSecond);
    EventsPerSecondStorageModel *eps = [[EventsPerSecondStorageModel alloc] init];
    eps.eventsPerSecond = eventsPerSecond;
    eps.side = @"Top";
    [self.eventsPerSecondArray addObject:eps];
    numEventsTop = 0;
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

- (IBAction)numOfTouchesEnabledButtonPressed:(UIButton *)sender {
    NSString *title = sender.currentTitle;
    int currentNumOfTouchesEnabled = [title intValue];
    if (currentNumOfTouchesEnabled>=5) currentNumOfTouchesEnabled = 0;
    else currentNumOfTouchesEnabled++;
    self.numOfEnabledTouchesPerSide = currentNumOfTouchesEnabled;
    [sender setTitle:[NSString stringWithFormat:@"%d",currentNumOfTouchesEnabled] forState:UIControlStateNormal];
    //sender.titleLabel.text = [NSString stringWithFormat:@"%d",currentNumOfTouchesEnabled];
}


- (NSString *)getEnabledSides {
    NSString *temp = [NSString stringWithFormat:@""];
    if (leftSide)  temp = [temp stringByAppendingString:@"left,"];
    if (rightSide) temp = [temp stringByAppendingString:@"right,"];
    if (topSide) temp = [temp stringByAppendingString:@"top,"];
    if (bottomSide) temp = [temp stringByAppendingString:@"bottom"];
    return temp;
}

@end
