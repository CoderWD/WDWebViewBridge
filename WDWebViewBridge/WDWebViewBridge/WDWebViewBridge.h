//
//  WDWebViewBridge.h
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/3.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDWebViewBridgeDelegate.h"

@interface WDWebViewBridge : NSObject<UIWebViewDelegate>

@property (nonatomic, assign) id<WDWebViewBridgeDelegate> delegate;
@property(nonatomic,strong) UIWebView *bridgeWebView;
@property(nonatomic,strong) NSMutableArray *messageArray;

-(instancetype)initWithBridgeWebView:(UIWebView*)webView;
//给javascript发消息
-(void)wdBridgeSend:(NSString*)sendMessage response:(WDWebViewBridgeFinish)responseBlock;
//用于收到js消息后响应到
-(void)resposeMessgeToJavaScript:(NSString*)responseMessage;
@end
