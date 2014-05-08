//
//  Testo.m
//  SoftModemRemote
//
//  Created by johannes on 5/5/14.
//  Copyright (c) 2014 9Lab. All rights reserved.
//

#import "Testo.h"

@interface Testo ()
@property (nonatomic,assign) SensorSampleDataObject *  myDataObject;


@end

@implementation Testo
@synthesize sendRequestDelegate;
@synthesize myDataObject;

-(id)init
{
    self = [super init];
    return self;
}
//inits with a dictionary holding a viewcontroller to be set as delegate for sendrequest stuff
-(id)initWithDictionary:(NSDictionary *)dictionary ;//= /* parse the JSON response to a dictionary */;
{
    NSLog(@"sensor init with dictionary");
    [self setSendRequestDelegate:[dictionary valueForKey:@"delegate"]];
    
    [self setMyDataObject:[dictionary valueForKey:@"dataObject"]];
    
    self = [super init];
    return self;
}



-(id)initWithString:(NSString *)string
{
    NSLog(@"sensor init with string");

    self = [super init];
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
    
    if([self.myDataObject.sampleDataDict valueForKey:@"data"])
    {
        // details view
        NSString * tmp=[self.myDataObject.sampleDataDict valueForKey:@"data"];
        [self.myTextView setText:tmp];
    }
    else
    {
        // new sample view
        NSLog(@"mydataobject is empty");
        [self.receiveDataProgress startAnimating];
        [self.sendRequestDelegate sendRequest:@"00"];
        [NSThread sleepForTimeInterval:0.04];           // This will sleep for 40 millis
        
    }
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) receivedChar:(char)input;
{
    if ([self.receiveDataProgress isAnimating]) {
        [self.receiveDataProgress stopAnimating];
    }
    
    self.myTextView.text = [self.myTextView.text stringByAppendingString:[NSString stringWithFormat:@"%c",input]];
    [self.myTextView scrollRangeToVisible:NSMakeRange([self.myTextView.text length], 0)];
    
    NSLog(@"testo received %c", input);
    
}

- (SensorSampleDataObject *)getDataObject
{
    [self.myDataObject setPlaceName:@"loppen haha"];
    NSDictionary *dictionary = @{
                                 @"data" : self.myTextView.text
                                 };
    [self.myDataObject setSampleDataDict:dictionary];
    return self.myDataObject;
}


@end
