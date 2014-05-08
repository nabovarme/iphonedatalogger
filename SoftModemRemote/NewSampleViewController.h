//
//  NewSampleViewController.h
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"

#import "ProtocolHelper.h"

@class NewSampleViewController;

@interface NewSampleViewController : UIViewController <CharReceiver,SensorViewControllerSendRequest>{
//    id<NewSampleViewControllerCancelSave> _cancelSaveDelegate;
//    id<NewSampleViewControllerReceivedChar> _receivedCharDelegate;
}
@property (assign, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) id<NewSampleViewControllerCancelSave> cancelSaveDelegate;
@property (nonatomic, assign) id<NewSampleViewControllerReceivedChar> receivedCharDelegate;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property ProtocolHelper* protocolHelper;

@property (nonatomic, assign) NSString * deviceName;

//for data storage
@property SensorSampleDataObject *  myDataObject;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;
- (SensorSampleDataObject *)getDataObject;


@end
