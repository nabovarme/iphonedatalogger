//
//  KeyLabelValueTextfieldCell.h
//  MeterLogger
//
//  Created by johannes on 5/12/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyLabelValueTextfieldCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextfield;
@end
