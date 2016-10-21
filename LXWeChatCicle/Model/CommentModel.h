//
//  CommentModel.h
//  LXWeChatCicle
//
//  Created by chuanglong02 on 16/10/20.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import <Foundation/Foundation.h>
//"commentId":"1",
//"commentUserId":97,
//"commentUserName":"怕瓦落地",
//"commentPhoto":"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160307/14573358906810.JPEG",
//"commentText":"杀马特遇见洗剪吹",
//"commentByUserId":"",
//"commentByUserName":"",
//"commentByPhoto":"",
//"createDate":1463641914000,
//"createDateStr":"2016-05-19 15:11",
//"checkStatus":"YES"

@interface CommentModel : NSObject

@property(nonatomic,copy)NSString *commentId;

@property(nonatomic,copy)NSString *commentUserId;

@property(nonatomic,copy)NSString *commentUserName;

@property(nonatomic,copy)NSString *commentPhoto;

@property(nonatomic,copy)NSString *commentText;
@property(nonatomic,copy)NSString *commentByUserId;
@property(nonatomic,copy)NSString *commentByUserName;
@property(nonatomic,copy)NSString *commentByPhoto;
@property(nonatomic,copy)NSString *createDateStr;
@property(nonatomic,copy)NSString *checkStatus;

@end
