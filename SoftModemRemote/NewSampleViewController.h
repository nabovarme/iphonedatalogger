//
//  NewSampleViewController.h
//  SoftModemRemote
//
//  Created by johannes on 4/24/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"
#import "CharReceiver.h"
#import <AVFoundation/AVAudioSession.h>



@class NewSampleViewController;
@class FSKSerialGenerator,CharReceiverDelegate;
@class AudioSignalAnalyzer, FSKSerialGenerator, FSKRecognizer;

@protocol NewSampleViewControllerDelegate <NSObject>
@required
- (void)NewSampleViewControllerDidCancel:(NewSampleViewController *)controller;
- (void)NewSampleViewControllerDidSave:(NewSampleViewController *)controller;
@end


@interface NewSampleViewController : UIViewController <CharReceiver, AVAudioSessionDelegate> {
    AudioSignalAnalyzer* _analyzer;
	FSKRecognizer* _recognizer;
    FSKSerialGenerator* _generator;
    id<NewSampleViewControllerDelegate> _delegate;
}
@property (nonatomic, retain) AudioSignalAnalyzer* analyzer;

@property (nonatomic, retain) FSKSerialGenerator* generator;

@property (nonatomic, assign) id delegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;

@end
