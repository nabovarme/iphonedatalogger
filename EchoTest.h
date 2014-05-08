//
//  EchoTest.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorSampleDataObject.h"
#import "NewSampleViewController.h"
#import "Protocols.h"
#import "SamplesEntity.h"
@class EchoTest;

@interface EchoTest : UIViewController <NewSampleViewControllerReceivedChar>{
  //  id<SensorViewControllerSendRequest> _sendRequestDelegate;

}

//@property (nonatomic, unsafe_unretained) id <SensorViewControllerSendRequest> sendRequestDelegate;
@property (nonatomic, assign) id<SensorViewControllerSendRequest> sendRequestDelegate;

@property (retain, nonatomic) IBOutlet UITextView *myTextView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *receiveDataProgress;
@property NSTimer *receiveTimer;

//- (NSString *) selectProtocolCommand;

//for testing



@end

