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

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@", [self class]);
        NSLog(@"%@", [super class]);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%@", [super class]);
        NSLog(@"%@", [self class]);
        NSLog(@"%@", [super class]);
    }
    return self;
}

static void stringCleanUp(__strong NSString **string)
{
    NSLog(@"%@", *string);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *s = [UITextField new];
    s.enableClipboard = YES;
    
    
    [self.fsd setEnableClipboard:YES];

    
    NSLog(@"%@", [self class]);
    NSLog(@"%@", [super class]);
    
    
    __strong NSString *string __attribute__((cleanup(stringCleanUp))) = @"yay";
    
//    [[[NSObject class] alloc] init][self.view.backgroundColor];
//    NSMutableDictionary *dict ;
//    dict[@"xxx"] = @"ccc";
//    id xx = dict[@"xxx"];
    

    
    
//    self.navigationController.enableBackGesture = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
