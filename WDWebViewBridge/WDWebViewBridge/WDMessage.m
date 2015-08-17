//
//  WDMessage.m
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/5.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

#import "WDMessage.h"

@implementation WDMessage
-(instancetype)init{
    self = [super init];
    if (self) {
        self.time_key = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    }
    return self;
}
@end
