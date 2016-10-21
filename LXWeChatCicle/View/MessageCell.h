//
//  MessageCell.h
//  LXWeChatCicle
//
//  Created by chuanglong02 on 16/10/20.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "JGGView.h"
#import "CommentCell.h"

@class MessageCell;
@class CommentModel;
@protocol MessageCellDelegate <NSObject>
- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath;
- (void)passCellHeightWithMessageModel:(MessageModel *)messageModel commentModel:(CommentModel *)commentModel atCommentIndexPath:(NSIndexPath *)commentIndexPath cellHeight:(CGFloat )cellHeight commentCell:(CommentCell *)commentCell messageCell:(MessageCell *)messageCell;
@end
@interface MessageCell : UITableViewCell
@property (nonatomic, strong) JGGView *jggView;
- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<MessageCellDelegate> delegate;

/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSIndexPath * indexPath);
/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,NSIndexPath * indexPath);

/**
 *  点击图片的block
 */
@property (nonatomic, copy)TapBlcok tapImageBlock;
/**
 *  点击文字的block
 */
@property (nonatomic, copy)void(^TapTextBlock)(UILabel *desLabel);
@end
