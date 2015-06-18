//
//  ViewController.m
//  DevelopTools
//
//  Created by Johnson on 6/17/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fsd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *s = [UITextField new];
    s.enableClipboard = YES;
    
    
    [self.fsd setEnableClipboard:YES];
    
//    self.navigationController.enableBackGesture = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
