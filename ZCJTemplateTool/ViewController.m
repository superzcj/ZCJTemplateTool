//
//  ViewController.m
//  ZCJTemplateTool
//
//  Created by inpark_1 on 2017/2/24.
//  Copyright © 2017年 inpark. All rights reserved.
//

#import "ViewController.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@interface ViewController()
@property (weak) IBOutlet NSTextField *classNameTF;
@property (weak) IBOutlet NSTextField *urlTF;
@property (weak) IBOutlet NSComboBox *typeCB;
@property (weak) IBOutlet NSTextField *param1TF;
@property (weak) IBOutlet NSTextField *param2TF;
@property (weak) IBOutlet NSTextField *param3TF;
@property (weak) IBOutlet NSTextField *param4TF;
@property (weak) IBOutlet NSTextField *param5TF;
@property (weak) IBOutlet NSTextField *param6TF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)generateAction:(id)sender {
    
    // Set up template engine with your chosen matcher.
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
//    [engine setDelegate:self];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    // Set up any needed global variables.
    // Global variables persist for the life of the engine, even when processing multiple templates.
    
    NSString *templatePath_h = [[NSBundle mainBundle] pathForResource:@"NetworkAPITemplater_h" ofType:@"txt"];
    NSString *templatePath_m = [[NSBundle mainBundle] pathForResource:@"NetworkAPITemplater_m" ofType:@"txt"];

    NSMutableArray *mArr = [NSMutableArray new];
    if (![_param1TF.stringValue isEqualToString:@""]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_param1TF.stringValue, @"key", @"NSString", @"value", nil];
        [mArr addObject:dic];
    }
    if (![_param2TF.stringValue isEqualToString:@""]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_param2TF.stringValue, @"key", @"NSString", @"value", nil];
        [mArr addObject:dic];
    }
    if (![_param3TF.stringValue isEqualToString:@""]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_param3TF.stringValue, @"key", @"NSString", @"value", nil];
        [mArr addObject:dic];
    }
    if (![_param4TF.stringValue isEqualToString:@""]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_param4TF.stringValue, @"key", @"NSString", @"value", nil];
        [mArr addObject:dic];
    }
    if (![_param5TF.stringValue isEqualToString:@""]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_param5TF.stringValue, @"key", @"NSString", @"value", nil];
        [mArr addObject:dic];
    }
    if (![_param6TF.stringValue isEqualToString:@""]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_param6TF.stringValue, @"key", @"NSString", @"value", nil];
        [mArr addObject:dic];
    }

    // Set up some variables for this specific template.
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               mArr, @"Param",
                               _classNameTF.stringValue, @"ClassName",
                               _urlTF.stringValue, @"Url",
                               [_typeCB objectValueOfSelectedItem], @"MethodType",
                               nil];
    
    // Process the template and display the results.
    NSString *resultH = [engine processTemplateInFileAtPath:templatePath_h withVariables:variables];
    NSString *resultM = [engine processTemplateInFileAtPath:templatePath_m withVariables:variables];

//    NSLog(@"Processed template:\r%@", result);
    
    NSString *bundel=[[NSBundle mainBundle] resourcePath];
    NSString *deskTopLocation=[[bundel substringToIndex:[bundel rangeOfString:@"Library"].location] stringByAppendingFormat:@"Desktop"];
    NSString *pathH = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h", _classNameTF.stringValue]];
    NSString *pathM = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", _classNameTF.stringValue]];
    BOOL isSuccessH = [resultH writeToFile:pathH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    BOOL isSuccessM = [resultM writeToFile:pathM atomically:YES encoding:NSUTF8StringEncoding error:nil];

    if (isSuccessH && isSuccessM) {
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }
    
//    [NSApp terminate:self];
}

@end
