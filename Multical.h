//
//  Multical.h
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
#import "Multical.h"
//#import "MeterLoggerProtocol.h"
//#define PROTO_IEC61107		(@"fc")

@class Multical;

@interface Multical : UIViewController <UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>

//- (void)sendMulticalRequest:(NSOperation *)theOperation;


@property (weak, nonatomic) IBOutlet UIProgressView *receiveDataProgressView;

@property NSTimer *receiveDataProgressTimer;
//-(id) respondWithReceiveCharDelegate;

@end

