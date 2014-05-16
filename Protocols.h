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

//#import "SampleDetailsViewController.h"
//#import "NewSampleViewController.h"



@class NewSampleViewController, DeviceSampleDataObject;

@protocol NewSampleViewControllerCancelSave <NSObject>
@optional
- (void)newSampleViewControllerDidCancel:(NewSampleViewController *)controller;
- (void)newSampleViewControllerDidSave:(NewSampleViewController *)controller;
@end

@protocol NewSampleViewControllerReceivedChar  <NSObject>
@optional
- (void) receivedChar:(char)input;
- (void)lort;
- (DeviceSampleDataObject*)getDataObject;
@end

@protocol DeviceViewControllerSendRequest  <NSObject>
@optional
-(void) sendRequest:(NSString*) hexStrings;
@end

