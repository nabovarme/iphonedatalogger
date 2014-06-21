//
//  Testo.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 Johannes Gaardsted Jørgensen <johannesgj@gmail.com> + Kristoffer Ek <stoffer@skulp.net>. All rights reserved.
//  This program is distributed under the terms of the GNU General Public License

#import <UIKit/UIKit.h>
#import "DeviceSampleDataObject.h"
#import "NewSampleViewController.h"
#import "Protocols.h"
#import "SamplesEntity.h"

#define PROTO_TESTO			(@"fe")

@class Testo;

@interface Testo : UIViewController <NewSampleViewControllerReceivedChar,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>{

}

@property (nonatomic, assign) id<DeviceViewControllerSendRequest> sendRequestDelegate;

@property (weak, nonatomic) IBOutlet UIProgressView *receiveDataProgressView;

@property NSTimer *receiveDataProgressTimer;

@end

