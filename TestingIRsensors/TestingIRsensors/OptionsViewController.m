//
//  OptionsViewController.m
//  TestingIRsensors
//
//  Created by Fuffr2 on 24/06/14.
//  Copyright (c) 2014 Fuffr2. All rights reserved.
//

#import "OptionsViewController.h"
#import "AppDelegate.h"

@interface OptionsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *brightnessTextField;
@property (weak, nonatomic) IBOutlet UITextField *surfaceTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *onOffSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *serverIPTextField;
@property (strong, nonatomic) AppDelegate *delegate;
@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [self.brightnessTextField setDelegate:self];
    [self.surfaceTextField setDelegate:self];
    [self.serverIPTextField setDelegate:self];
}


- (IBAction)brightnessTextFieldChanged:(UITextField *)sender {
    self.delegate.brightness = self.brightnessTextField.text;
}

- (IBAction)surfaceTextFieldChanged:(UITextField *)sender {
    self.delegate.surface = self.surfaceTextField.text;
}

- (IBAction)serverIPTextFiendChanged:(UITextField *)sender {
    self.delegate.serverIP = self.serverIPTextField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.brightnessTextField resignFirstResponder];
    [self.surfaceTextField resignFirstResponder];
    [self.serverIPTextField resignFirstResponder];
    return YES;
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
