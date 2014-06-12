//
//  EventsPerSecondSideModel.h
//  TestingIRsensors
//
//  Created by Fuffr2 on 12/06/14.
//  Copyright (c) 2014 Fuffr2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsPerSecondSideModel : NSObject

@property (nonatomic) double startTime;
@property (nonatomic) double stopTime;
@property (nonatomic) int numOfEvents;
@property (nonatomic) int numOfActiveTouches;
@property (nonatomic) int sideEnabled;
@property (nonatomic) int highestNumOfActiveTouches;

@end
