//
//  EventsPerSecondStorageModel.h
//  TestingIRsensors
//
//  Created by Fuffr2 on 04/06/14.
//  Copyright (c) 2014 Fuffr2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsPerSecondStorageModel : NSObject 

@property (nonatomic) int eventId;
@property (nonatomic) float eventsPerSecond;
@property (nonatomic, strong) NSString *side;
@property (nonatomic) int numOfEnabledSides;
@property (nonatomic, strong) NSString *enabledSides;
@property (nonatomic) int numOfSidesActiveAtOnce;
@property (nonatomic, strong) NSString *sidesActiveAtOnce;
@property (nonatomic) int numOfTouchesActiveAtOnce;
@property (nonatomic) float durationInSeconds;
@property (nonatomic, strong) NSString *brightness;
@property (nonatomic, strong) NSString *surface;

@end
