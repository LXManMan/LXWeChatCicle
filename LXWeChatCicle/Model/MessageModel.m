//
//  MessageModel.m
//  LXWeChatCicle
//
//  Created by chuanglong02 on 16/10/20.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"commentMessages" : @"CommentModel",
             };
}
@end
