//
//  ViewController.m
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/3.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

#import "ViewController.h"
#import "WDWebViewBridge.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bridge = [[WDWebViewBridge alloc] initWithBridgeWebView:_contentWebView];
    [_bridge setDelegate:self];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Example" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_contentWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//发送消息给js
- (IBAction)sendMessageToJavaScriptAction:(UIButton *)sender {
    [_bridge wdBridgeSend:@"app发消息给js" response:^(id message) {
        NSLog(@"js的反馈：%@",message);
    }];
}


//收js消息的监听
-(void)wdBridgelistener:(WDWebViewBridge *)wdBridge message:(NSString *)message{
    
    //响应给js，非必需
    [wdBridge resposeMessgeToJavaScript:message];
}


/*
 原UIWebView的代理方法，使用WDBridge后的函数
 是否调用取决WDBridge的delegate
 */
-(void)wdWebViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)wdWebViewDidFinishLoad:(UIWebView *)webView{
    
}
-(BOOL)wdWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

-(void)wdWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
