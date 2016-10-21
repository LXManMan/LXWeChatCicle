//
//  MessageModel.h
//  LXWeChatCicle
//
//  Created by chuanglong02 on 16/10/20.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject


@property(nonatomic,copy)NSString *cid;
///发布说说的id

@property(nonatomic,copy)NSString *message_id;

///发布说说的展开状态
@property(nonatomic,assign)BOOL isExpand;
///发布说说的内容

@property(nonatomic,copy)NSString *message;

///发布说说的时间标签

@property(nonatomic,copy)NSString *timeTag;

///发布说说的类型（可能含有视频）

@property(nonatomic,copy)NSString *message_type;

///发布说说者id

@property(nonatomic,copy)NSString *userId;

///发布说说者名字

@property(nonatomic,copy)NSString *userName;
///发布说说者头像

@property(nonatomic,copy)NSString *photo;
///评论小图

@property(nonatomic,copy)NSMutableArray *messageSmallPics;

///评论大图

@property(nonatomic,copy)NSMutableArray *messageBigPics;
///评论相关的所有信息

@property(nonatomic,copy)NSMutableArray *commentMessages;

@property (nonatomic, assign) BOOL shouldUpdateCache;

@end
//"cid":"1",
//"message_id":656,
//"message":"杀马特一词源于英文单词smart,可以译为时尚的；聪明的，在中国正式发展始于2008年，是结合日本视觉系和欧美摇滚的结合体，喜欢并盲目模仿日本视觉系摇滚乐队的衣服、头发等等，看不惯的网友们将他们称为“山寨系”，“脑残”划上等号脑残族并列。",
//"createDate":1463646327000,
//"timeTag":"2天前",
//"createDateStr":"2016-05-19 16:25",
//"objId":"f1562484",
//"message_type":"text",
//"checkStatus":"YES",
//"userId":82,
//"userName":"杀马特",
//"photo":"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/15914867203-1461920972642.jpg",
//"messageSmallPics":[
//                    "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160503/14622764778932thumbnail.jpg",
//                    "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160426/14616659617000.jpg",
//                    "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160519/14636463273461.JPEG"
//                    ],
//"messageBigPics":[
//                  "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160503/14622764778932thumbnail.jpg",
//                  "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160426/14616659617000.jpg",
//                  "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160519/14636463273461.JPEG"
//                  ],
//"commentMessages":
