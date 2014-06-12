//
//  IRSensorRangeDrawingViewController.m
//  TestingIRsensors
//
//  Created by Fuffr1 on 05/06/14.
//  Copyright (c) 2014 Fuffr1. All rights reserved.
//

#import "IRSensorRangeViewController.h"
#import "IRSensorRangeModel.h"

@interface IRSensorRangeViewController ()
@property float x, width;
@property float y, height;
@property (nonatomic) NSMutableArray *listOfIRSensorModels;
@property (nonatomic) NSMutableArray *listOfTouches;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) CGRect rect;
@property (nonatomic) NSString *side;
@end

@implementation IRSensorRangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFuffr];
    self.width = self.view.frame.size.width;
    self.height = self.view.frame.size.height;
}

-(NSMutableArray *)listOfIRSensorModels{
    if(!_listOfIRSensorModels){
        _listOfIRSensorModels = [[NSMutableArray alloc]init];
    }
    return _listOfIRSensorModels;
}
-(NSMutableArray *)listOfTouches{
    if(!_listOfTouches){
        _listOfTouches = [[NSMutableArray alloc]init];
    }
    return _listOfTouches;
}

-(void)setupFuffr{
    FFRTouchManager* manager = [FFRTouchManager sharedManager];
    
    [manager
     enableSides: FFRSideLeft | FFRSideRight | FFRSideTop | FFRSideBottom
     touchesPerSide: @1];
    
    
    FFRTapGestureRecognizer* tap = [FFRTapGestureRecognizer new];
    tap.side = FFRSideRight | FFRSideLeft | FFRSideTop | FFRSideBottom;
    [tap addTarget: self action: @selector(onTap:)];
    [manager addGestureRecognizer: tap];
    
}


-(void)onTap:(FFRTapGestureRecognizer *)sender{
    IRSensorRangeModel *model = [[IRSensorRangeModel alloc]init];
    switch (sender.touch.side) {
        case FFRSideNotSet:
            model.side = @"NoSide";
            break;
        case FFRSideTop:
            model.side = @"Top";
            break;
        case FFRSideBottom:
            model.side = @"Bottom";
            break;
        case FFRSideLeft:
            model.side = @"Left";
            break;
        case FFRSideRight:
            model.side = @"Right";
            break;
    }
    model.x = sender.touch.normalizedLocation.x * self.width;
    model.y = sender.touch.normalizedLocation.y * self.height;
    NSLog(@"%@ X: %f", self.side, sender.touch.normalizedLocation.x*self.width);
    NSLog(@"%@ Y: %f", self.side, sender.touch.normalizedLocation.y*self.height);
    [self.listOfIRSensorModels addObject:model];
    [self.listOfTouches addObject:sender.touch];
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self drawStuff];
                   });
}

-(void)drawStuff{
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(FFRTouch *touch in self.listOfTouches){
        if (touch.phase != UITouchPhaseEnded)
        {
            self.rect = CGRectMake(touch.normalizedLocation.x * self.imageView.bounds.size.width, touch.normalizedLocation.y * self.imageView.bounds.size.height, 5, 5);
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextAddRect(context, self.rect);
            CGContextFillEllipseInRect(context, self.rect);
        }
    }
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}



- (IBAction)sendToServer:(UIButton *)sender {
    IRSensorRangeModel *model;
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<[self.listOfIRSensorModels count]; i++) {
        model = [self.listOfIRSensorModels objectAtIndex:i];
        NSLog(@"%@",[self.listOfIRSensorModels objectAtIndex:i]);
        [writeString appendString:[NSString stringWithFormat:@"%@, %f, %f, %d, \n", model.side, model.x, model.y, model.antalActivaSidor]];
    }
    
    
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
    
     NSData *data = [[NSData alloc] initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
     [outputStream write:[data bytes] maxLength:[data length]];
    
    [inputStream close];
    [outputStream close];
    
}



- (IBAction)goback:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
