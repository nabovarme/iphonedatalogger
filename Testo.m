//
//  Testo.m
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "Testo.h"

@interface Testo ()

@end

@implementation Testo

-(id)init
{
    self = [super init];
   // self = [self initWithNibName:@"Testo" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"content loaded with %@",nibNameOrNil);
        // Custom initialization

    }
    NSLog(@"content loaded");
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // show instruction alert
    _pressPrintAlertView = [[UIAlertView alloc] initWithTitle:@"Press Print on Testo"
                                                      message:@"Hold the device close the the MeterLogger while receiving data"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [_pressPrintAlertView setDelegate:self];
    [_pressPrintAlertView show];

    /*
    // send command via FSK
    NSString *hexString = [NSString stringWithUTF8String:"\0"];
    [[[UIApplication sharedApplication] delegate] sendRequest:hexString];
    [hexString release];
    */

    [self.receiveDataProgress startAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.myTextView release];
    [self.receiveDataProgress release];
    [super dealloc];
}


- (void) receivedChar:(char)input;
{
    if (_pressPrintAlertView) {
        [_pressPrintAlertView dismissWithClickedButtonIndex:-1 animated:YES];
        [_pressPrintAlertView release];
        _pressPrintAlertView = nil;
        NSLog(@"alert dismissed by data in");
    }

    if ([self.receiveDataProgress isAnimating]) {
        [self.receiveDataProgress stopAnimating];
    }

    self.myTextView.text = [_myTextView.text stringByAppendingString:[NSString stringWithFormat:@"%c",input]];
    [self.myTextView scrollRangeToVisible:NSMakeRange([_myTextView.text length], 0)];
    
    NSLog(@"testo received %c", input);
    
}

// called by pressPrintAlertView when it was canceled
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"alert dismissed by button");
    [_pressPrintAlertView release];
    _pressPrintAlertView = nil;
}

- (NSString *) selectProtocolCommand {
    return @"00";
}

@end
