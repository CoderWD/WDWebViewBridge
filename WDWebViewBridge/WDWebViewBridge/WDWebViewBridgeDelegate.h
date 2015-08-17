//
//  WDWebViewBridgeDelegate.h
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/3.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WDWebViewBridgeFinish) (id message);
@class WDWebViewBridge;
@protocol WDWebViewBridgeDelegate <NSObject>
-(void)wdBridgelistener:(WDWebViewBridge*)wdBridge message:(NSString*)message;
@required

@optional
-(void)wdWebViewDidStartLoad:(UIWebView *)webView;
-(void)wdWebViewDidFinishLoad:(UIWebView *)webView;
-(BOOL)wdWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
-(void)wdWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
