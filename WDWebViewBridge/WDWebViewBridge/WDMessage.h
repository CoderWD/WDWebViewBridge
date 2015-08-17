//
//  WDMessage.h
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/5.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDWebViewBridgeDelegate.h"
@interface WDMessage : NSObject
@property(nonatomic,assign) WDWebViewBridgeFinish sendBackBlock;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *time_key;
@end
