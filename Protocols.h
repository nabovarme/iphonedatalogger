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

@protocol NewSampleViewControllerReceivedChar  <NSObject>
@optional
- (void) receivedChar:(unsigned char)input;
-(id) respondWithReceiveCharDelegate;
- (DeviceSampleDataObject*)getDataObject;
@end

@protocol DeviceViewControllerSendToNewSampleViewController  <NSObject>
@optional
-(void) updateProgressBar:(NSNumber *) procentage;
-(void) sendRequest:(NSString*) hexStrings;
@end

@protocol deviceModelUpdated <NSObject>
@optional
- (void)doneReceiving:(NSDictionary * )responseDataDict;
@end

#import <Foundation/Foundation.h>


