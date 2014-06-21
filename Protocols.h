//
//  Protocols.h
//  SoftModemRemote
//
//  Created by johannes on 5/6/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

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
- (void) receivedChar:(unsigned char)input;
- (void)lort;
- (DeviceSampleDataObject*)getDataObject;
@end

@protocol DeviceViewControllerSendRequest  <NSObject>
@optional
//updateProgressBar
-(void) sendRequest:(NSString*) hexStrings;
@end

