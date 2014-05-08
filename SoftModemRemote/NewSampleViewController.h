//
//  NewSampleViewController.h
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"

#import "CharReceiverDelegate.h"
#import "ProtocolHelper.h"
#import "CharReceiver.h"
#import "Protocols.h"
#import "SensorSampleDataObject.h"
#import "SamplesEntity.h"

@class NewSampleViewController;

@interface NewSampleViewController : UIViewController <CharReceiver,SensorViewControllerSendRequest>{
    id<NewSampleViewControllerCancelSave> _cancelSaveDelegate;
    id<NewSampleViewControllerReceivedChar> _receivedCharDelegate;
}
@property (assign, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) id cancelSaveDelegate;
@property (nonatomic, assign) id receivedCharDelegate;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, assign) ProtocolHelper* protocolHelper;

@property (nonatomic, assign) NSString * deviceName;

//for data storage
@property (nonatomic,assign) SensorSampleDataObject *  myDataObject;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;
- (SensorSampleDataObject *)getDataObject;


@end
