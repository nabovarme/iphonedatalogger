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
    [_label setText:@"nullcat"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
      [_label release];
    [super dealloc];
}

- (IBAction)lol:(UIButton *)sender {
    [_label setText:@"lol"];
}
- (IBAction)cat:(UIButton *)sender {
    [_label setText:@"cat"];

}
- (void) receivedChar:(char)input;
{
    
}
@end
