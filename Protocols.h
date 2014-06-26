//
//  Protocols.h
//  SoftModemRemote
//
//  Created by johannes on 5/6/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License



//#import "SampleDetailsViewController.h"
//#import "NewSampleViewController.h"




@class NewSampleViewController, DeviceSampleDataObject;

@protocol NewSampleViewControllerCancelSave <NSObject>
@optional
- (void)newSampleViewControllerDidCancel:(NewSampleViewController *)controller;
- (void)newSampleViewControllerDidSave:(NewSampleViewController *)controller;
@end

@protocol NewSampleViewControllerSendToDeviceViewController  <NSObject> //kan måske slettes
@optional
-(id) respondWithReceiveCharDelegate;
- (DeviceSampleDataObject*)getDataObject;
@end

@protocol NewSampleViewControllerSendToDeviceRequest <NSObject>
@optional
- (void) receivedChar:(unsigned char)input;
@end

@protocol DeviceRequestSendToNewSampleViewController  <NSObject>
@optional
-(void) updateProgressBarWithFloat:(NSNumber *) floatValue andTime:(NSNumber*)time;
-(void) sendRequest:(NSString*) hexStrings;
@end

@protocol DeviceRequestSendToDeviceViewController <NSObject>
@optional
- (void)doneReceiving:(NSDictionary * )responseDataDict;
@end

//#import <Foundation/Foundation.h>


