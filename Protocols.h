//
//  Protocols.h
//  SoftModemRemote
//
//  Created by johannes on 5/6/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAppDelegate.h"
#import <UIKit/UIKit.h>

#import "NewSampleViewController.h"

@class NewSampleViewController;

@protocol NewSampleViewControllerCancelSave <NSObject>
@optional
- (void)NewSampleViewControllerDidCancel:(NewSampleViewController *)controller;
- (void)NewSampleViewControllerDidSave:(NewSampleViewController *)controller;
@end

@protocol NewSampleViewControllerReceivedChar  <NSObject>
@optional
- (void) receivedChar:(char)input;
@end

@protocol SensorViewControllerSendRequest  <NSObject>
@optional
-(void) sendRequest:(NSString*) hexStrings;
@end

