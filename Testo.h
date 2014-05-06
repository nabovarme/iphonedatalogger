//
//  Testo.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorSampleDataObject.h"
#import "NewSampleViewController.h"
@class Testo;//,NewSampleViewController;

@interface Testo : UIViewController <NewSampleViewControllerDelegate>{
    UITextView *myTextView;
    UIActivityIndicatorView *receiveDataProgress;
    UIAlertView *_pressPrintAlertView;
}
@property (retain, nonatomic) IBOutlet UITextView *myTextView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *receiveDataProgress;

- (NSString *) selectProtocolCommand;
//-(SensorSampleDataObject *) getSensorDataObject;

@end

