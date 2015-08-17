//
//  WDWebViewBridge.m
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/3.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

#import "WDWebViewBridge.h"
#import "WDMessage.h"

@implementation WDWebViewBridge

-(instancetype)initWithBridgeWebView:(UIWebView*)webView{
    self = [super init];
    if (self) {
        [self setBridgeWebView:webView];
        [webView setDelegate:self];
        _messageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //植入js
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"WDWebViewBridge" ofType:@"js"];
    NSString *javaScript = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
    
    [webView stringByEvaluatingJavaScriptFromString:javaScript];
    if ([_delegate respondsToSelector:@selector(wdWebViewDidStartLoad:)]) {
        [_delegate wdWebViewDidStartLoad:webView];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([_delegate respondsToSelector:@selector(wdWebViewDidFinishLoad:)]) {
        [_delegate wdWebViewDidFinishLoad:webView];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //过的URL解码
    NSString *url = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //接收到js发来的消息
    if ([url hasPrefix:@"wdbridgesend://"]) {
        //js发来的消息，为任意格式的字符串
        NSString *message = [url stringByReplacingOccurrencesOfString:@"wdbridgesend://" withString:@""];
        if ([_delegate respondsToSelector:@selector(wdBridgelistener:message:)]) {
            [_delegate wdBridgelistener:self message:message];
        }
        return NO;
    }
    //app发出去消息的回调
    if ([url hasPrefix:@"wdbridgeresponse://"]) {
        //回调过来的信息
        NSString *message = [url stringByReplacingOccurrencesOfString:@"wdbridgeresponse://" withString:@""];
        NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSMutableDictionary *backObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        WDMessage *currentMessage = nil;
        for (WDMessage *message in _messageArray) {
            if ([backObject[@"time_key"] isEqualToString:message.time_key]) {
                currentMessage = message;
            }
        }
        currentMessage.sendBackBlock(backObject[@"sendMessage"]);
        [_messageArray removeObject:currentMessage];
        return NO;
    }
    
    if ([_delegate respondsToSelector:@selector(wdWebView:shouldStartLoadWithRequest:navigationType:)]) {
        [_delegate wdWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([_delegate respondsToSelector:@selector(wdWebView:didFailLoadWithError:)]) {
        [_delegate wdWebView:webView didFailLoadWithError:error];
    }
}

-(void)wdBridgeSend:(NSString*)sendMessage response:(WDWebViewBridgeFinish)responseBlock{
    WDMessage *message = [[WDMessage alloc] init];
    [message setSendBackBlock:responseBlock];
    [message setContent:sendMessage];
    [_messageArray addObject:message];
    
    NSMutableDictionary *messageDictionary = [NSMutableDictionary dictionary];
    [messageDictionary setObject:message.time_key forKey:@"time_key"];
    [messageDictionary setObject:message.content forKey:@"sendMessage"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *javaScript = [NSString stringWithFormat:@"AppBridge.monitorAppMessage('%@')",json];
    javaScript = [javaScript stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    javaScript = [javaScript stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    javaScript = [javaScript stringByReplacingOccurrencesOfString:@" " withString:@""];
    [_bridgeWebView stringByEvaluatingJavaScriptFromString:javaScript];
}

-(void)resposeMessgeToJavaScript:(NSString*)responseMessage{
    NSString *message = [NSString stringWithFormat:@"AppBridge.appReceiveFinish('%@')",responseMessage];
    [_bridgeWebView stringByEvaluatingJavaScriptFromString:message];
}

@end
