//
//  Testo.h
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorSampleDataObject.h"
@class Testo;

@interface Testo : UIViewController

- (void) receivedChar:(char)input;
- (IBAction)lol:(UIButton *)sender;
- (IBAction)cat:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UILabel *label;

-(SensorSampleDataObject *) getSensorDataObject;
@end

