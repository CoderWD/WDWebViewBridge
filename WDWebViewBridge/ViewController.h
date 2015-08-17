//
//  ViewController.h
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/3.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDWebViewBridgeDelegate.h"
@class WDWebViewBridge;
@interface ViewController : UIViewController<WDWebViewBridgeDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) WDWebViewBridge *bridge;

@end

