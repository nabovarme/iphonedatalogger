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
@class EchoTest;

@interface EchoTest : UIViewController <NewSampleViewControllerDelegate>{
    UIAlertView *_pressPrintAlertView;
}
@property (retain, nonatomic) IBOutlet UITextView *myTextView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *receiveDataProgress;



-(SensorSampleDataObject *) getSensorDataObject;

@end

