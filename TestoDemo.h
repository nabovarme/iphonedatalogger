//
//  TestoDemo.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceSampleDataObject.h"
#import "NewSampleViewController.h"
#import "Protocols.h"
#import "SamplesEntity.h"
@class TestoDemo;

@interface TestoDemo : UIViewController <NewSampleViewControllerReceivedChar>{

}

@property (nonatomic, assign) id<DeviceViewControllerSendRequest> sendRequestDelegate;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *receiveDataProgress;
@property NSTimer *receiveTimer;

@end

