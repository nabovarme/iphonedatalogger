//
//  KeyLabelValueTextfieldCell.m
//  MeterLogger
//
//  Created by johannes on 5/12/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "KeyLabelValueTextfieldCell.h"

@implementation KeyLabelValueTextfieldCell
@synthesize keyLabel;
@synthesize valueTextfield;

- (void)awakeFromNib
{
    [self.valueTextfield setDelegate:self];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)textfieldEditingDidEnd:(UITextField *)sender {
    NSLog(@"lol%@",sender.text);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
