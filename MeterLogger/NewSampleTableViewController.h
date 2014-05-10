//
//  NewSampleTableViewController.h
//  SoftModemRemote
//
//  Created by johannes on 5/3/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLAppDelegate.h"
#import "CharReceiver.h"
#import <AVFoundation/AVAudioSession.h>

@class NewSampleTableViewController;
@class FSKSerialGenerator,CharReceiverDelegate;
@class AudioSignalAnalyzer, FSKSerialGenerator, FSKRecognizer;


@protocol NewSampleTableViewControllerDelegate <NSObject>
@required
- (void)NewSampleTableViewControllerDidCancel:(NewSampleTableViewController *)controller;
- (void)NewSampleTableViewControllerDidSave:(NewSampleTableViewController *)controller;
@end

@interface NewSampleTableViewController : UITableViewController <CharReceiver, AVAudioSessionDelegate> {
    AudioSignalAnalyzer* _analyzer;
	FSKRecognizer* _recognizer;
    FSKSerialGenerator* _generator;
    id<NewSampleTableViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) AudioSignalAnalyzer* analyzer;

@property (nonatomic, retain) FSKSerialGenerator* generator;

@property (nonatomic, assign) id delegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;

@end
