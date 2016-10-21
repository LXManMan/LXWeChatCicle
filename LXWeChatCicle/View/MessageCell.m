//
//  MessageCell.m
//  LXWeChatCicle
//
//  Created by chuanglong02 on 16/10/20.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "MessageCell.h"
#import "WMPlayer.h"
#import "CommentModel.h"
@interface MessageCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIImageView *headIamgeView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)LxButton *moreBtn;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)WMPlayer *wmPlayer;
@property(nonatomic,strong)MessageModel *messageModel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
@implementation MessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //子视图
        [self setupUI];
        //子视图添加事件
        [self addActionOrGesture];
        //子视图添加约束
        [self setupConstraints];
        
    }
    return  self;
}
-(void)setupUI{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.descLabel];

    [self.contentView addSubview:self.headIamgeView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.jggView];
    [self.contentView addSubview:self.commentBtn];

    
}
-(void)addActionOrGesture
{
    UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapText:)];
    [self.descLabel addGestureRecognizer:tapText];
    
     [self.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupConstraints{
    
   [self.headIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.top.mas_equalTo(kGAP);
       make.width.height.mas_equalTo(kAvatar_Size);
   }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIamgeView.mas_right).offset(kGAP);
        make.top.mas_equalTo(self.headIamgeView);
        make.right.mas_equalTo(-kGAP);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descLabel);
        make.top.mas_equalTo(self.descLabel.mas_bottom);
    }];
    
   
    [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kGAP);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.descLabel);
        make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(24);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jggView);
        make.top.mas_equalTo(self.commentBtn.mas_bottom).offset(kGAP);
        make.right.mas_equalTo(-kGAP);
    }];
    
    self.hyb_lastViewInCell = self.tableView;
    self.hyb_bottomOffsetToCell = 0.0;
}
-(void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath
{
   //外层cell 对应的 行
    self.indexPath = indexPath;
    self.messageModel = model;
    //赋值
    //名字
    self.nameLabel.text = model.userName;
    
    //头像
    [self.headIamgeView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
    NSMutableParagraphStyle *muStyle =[[NSMutableParagraphStyle alloc]init];
    
    muStyle.lineSpacing = 3;//设置行间距离
    muStyle.alignment = NSTextAlignmentLeft;//对齐方式

    NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:model.message];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attrString.length)];//下划线
    [attrString addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, attrString.length)];
    self.descLabel.attributedText = attrString;
    self.descLabel.highlightedTextColor =[UIColor redColor];//设置文本高亮显示颜色，与highlighted一起使用。
    self.descLabel.highlighted = YES; //高亮状态是否打开
    self.descLabel.enabled = YES;//设置文字内容是否可变
    self.descLabel.userInteractionEnabled = YES;//设置标签是否忽略或移除用户交互。默认为NO
    
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:muStyle};
    CGFloat h =[model.message boundingRectWithSize:CGSizeMake(Device_Width - kGAP - kAvatar_Size - 2 *kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + 0.5;
    if ( h <= 60 ) {
         [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(self.descLabel);
             make.top.mas_equalTo(self.descLabel.mas_bottom);
             make.size.mas_equalTo(CGSizeMake(0, 0));
         }];
    }else
    {
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
    }
    
    if (model.isExpand) {//展开
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
            make.height.mas_equalTo(h);
        }];
    }else // 收齐
    {
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
            make.height.mas_lessThanOrEqualTo(60);
        }];
    }
    self.moreBtn.selected = model.isExpand;
    
    
    
    CGFloat jjg_height  = 0.0;
    CGFloat jjg_width = 0.0;
    if (model.messageBigPics.count>0&&model.messageBigPics.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (model.messageBigPics.count)*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else if (model.messageBigPics.count>3&&model.messageBigPics.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else  if (model.messageBigPics.count>6&&model.messageBigPics.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }
    
   
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    ///布局九宫格
    [self.jggView JGGView:self.jggView DataSource:model.messageBigPics completeBlock:^(NSInteger index, NSArray *dataSource, NSIndexPath *indexpath) {
        self.tapImageBlock(index,dataSource,self.indexPath);
    }];
    
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kJGG_GAP);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
    
    
    CGFloat tableViewHeight = 0;
    for (CommentModel *commentModel in model.commentMessages) {
         CGFloat cellHeight =[CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
             CommentCell *cell = (CommentCell *)sourceCell;
             [cell configCellWithModel:commentModel];
         } cache:^NSDictionary *{
             return @{kHYBCacheUniqueKey : commentModel.commentId,
                      kHYBCacheStateKey : @"",
                      kHYBRecalculateForStateKey : @(YES)};
         }];
        tableViewHeight += cellHeight;

    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    CommentModel *model = [self.messageModel.commentMessages objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModel.commentMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = [self.messageModel.commentMessages objectAtIndex:indexPath.row];
    CGFloat cell_height = [CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        CommentCell *cell = (CommentCell *)sourceCell;
        [cell configCellWithModel:model];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : model.commentId,
                                kHYBCacheStateKey : @"",
                                kHYBRecalculateForStateKey : @(NO)};
        //        model.shouldUpdateCache = NO;
        return cache;
    }];
    return cell_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    CommentModel *commentModel = [self.messageModel.commentMessages objectAtIndex:indexPath.row];
    CGFloat cell_height = [CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        CommentCell *cell = (CommentCell *)sourceCell;
        
        
        [cell configCellWithModel:commentModel];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : commentModel.commentId,
                                kHYBCacheStateKey : @"",
                                kHYBRecalculateForStateKey : @(NO)};
        //        model.shouldUpdateCache = NO;
        return cache;
    }];

    if ([self.delegate respondsToSelector:@selector(passCellHeightWithMessageModel:commentModel:atCommentIndexPath:cellHeight:commentCell:messageCell:)]) {
        self.messageModel.shouldUpdateCache = YES;
        CommentCell *commetCell =  (CommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self.delegate passCellHeightWithMessageModel:_messageModel commentModel:commentModel atCommentIndexPath:indexPath cellHeight:cell_height commentCell:commetCell messageCell:self];
    }

    
}

#pragma mark--点击事件----
-(void)tapText:(UITapGestureRecognizer *)tap{
    if (self.TapTextBlock) {
        UILabel *descLabel = (UILabel *)tap.view;
        self.TapTextBlock(descLabel);
    }
}
-(void)moreAction:(UIButton *)sender{
    //    sender.selected = !sender.selected;
    if (self.MoreBtnClickBlock) {
        self.MoreBtnClickBlock(sender,self.indexPath);
    }
}
-(void)commentAction:(UIButton *)sender{
    if (self.CommentBtnClickBlock) {
        self.CommentBtnClickBlock(sender,self.indexPath);
    }
}
#pragma mark---懒加载----
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel =[UILabel LXLabelWithTextNoFrame:nil textColor:[UIColor colorWithRed:(54/255.0) green:(71/255.0) blue:(121/255.0) alpha:0.9] backgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14.0] textAlignment:NSTextAlignmentLeft];
        _nameLabel.preferredMaxLayoutWidth =Device_Width - kGAP-kAvatar_Size - 2*kGAP-kGAP;
        _nameLabel.numberOfLines = 0;
     }
    return _nameLabel;
}
-(UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel =[UILabel LXLabelWithTextNoFrame:nil textColor:[UIColor whiteColor] backgroundColor:[UIColor groupTableViewBackgroundColor] font:[UIFont systemFontOfSize:14.0] textAlignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 0;
        _descLabel.preferredMaxLayoutWidth = Device_Width - kGAP-kAvatar_Size ;
    }
    return _descLabel;
}
-(UIImageView *)headIamgeView
{
    if (!_headIamgeView) {
        _headIamgeView =[[UIImageView alloc]init];
        _headIamgeView.backgroundColor =[UIColor whiteColor];
        _headIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headIamgeView;
}
-(LxButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn =[LxButton LXButtonNoFrameWithTitle:@"全文" titleFont:[UIFont systemFontOfSize:14.0] Image:nil backgroundImage:nil backgroundColor:[UIColor whiteColor] titleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]];
        [_moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateSelected];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _moreBtn.selected = NO;
       
    }
    return _moreBtn;
}
-(UIButton *)commentBtn
{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.backgroundColor = [UIColor whiteColor];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setTitle:@"评论" forState:UIControlStateSelected];
        [_commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _commentBtn.layer.borderWidth = 1;
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateSelected];
        _commentBtn.layer.cornerRadius = 24/2;
    }
    return _commentBtn;
   
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView =[[UITableView alloc]init];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
-(JGGView *)jggView
{
    if (!_jggView) {
        _jggView = [JGGView new];
    }
    return _jggView;
}
@end
