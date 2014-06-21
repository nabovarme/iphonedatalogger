//
//  NewSampleViewController.h
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"

#import "ProtocolHelper.h"

@class NewSampleViewController;

@interface NewSampleViewController : UIViewController <CharReceiver,DeviceViewControllerSendRequest,UIAlertViewDelegate>{
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
@property DeviceSampleDataObject *  myDataObject;
-(void) terminate;

- (DeviceSampleDataObject *)getDataObject;


@end
