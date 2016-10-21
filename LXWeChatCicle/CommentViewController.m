//
//  CommentViewController.m
//  LXWeChatCicle
//
//  Created by chuanglong02 on 16/10/20.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "CommentViewController.h"
#import "MessageModel.h"
#import "CommentModel.h"
#import "MessageCell.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource,MessageCellDelegate,UIScrollViewDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource>
@property(nonatomic,strong)UITableView *commentTableview;//评论外层UItableview
@property(nonatomic,strong)NSMutableArray *dataA;
@property (nonatomic, assign) CGFloat history_Y_offset;//记录table的offset.y
@property (nonatomic, assign) CGFloat seletedCellHeight;//记录点击cell的高度，高度由代理传过来
////专门用来回复选中的cell的model
@property (nonatomic, strong) CommentModel *replayTheSeletedCellModel;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
//
@property (nonatomic, assign) BOOL needUpdateOffset;//控制是否刷新table的offset
//
@property (nonatomic,copy)NSIndexPath *currentIndexPath;
@end
static NSString *cellIndentifier = @"cell";
@implementation CommentViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //        //注册键盘出现NSNotification
        //        [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                 selector:@selector(keyboardWillShow:)
        //                                                     name:UIKeyboardWillShowNotification object:nil];
        //
        //
        //        //注册键盘隐藏NSNotification
        //        [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                 selector:@selector(keyboardWillHide:)
        //                                                     name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
#pragma mark--聊天框的init 与 代理方法----
-(ChatKeyBoard *)chatKeyBoard
{
    if (!_chatKeyBoard) {
        _chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}
- (void)chatKeyBoardSendText:(NSString *)text{
    //    MessageModel *messageModel = [self.dataSource objectAtIndex:self.currentIndexPath.row];
    //    messageModel.shouldUpdateCache = YES;
    //
    //    //创建一个新的CommentModel,并给相应的属性赋值，然后加到评论数组的最后，reloadData
    //    CommentModel *commentModel = [[CommentModel alloc]init];
    //    commentModel.commentUserName = @"文明";
    //    commentModel.commentUserId = @"274";
    //    commentModel.commentPhoto = @"http://q.qlogo.cn/qqapp/1104706859/189AA89FAADD207E76D066059F924AE0/100";
    //    commentModel.commentByUserName = self.replayTheSeletedCellModel?self.replayTheSeletedCellModel.commentUserName:@"";
    //    commentModel.commentId = [NSString stringWithFormat:@"%i",[self getRandomNumber:100 to:1000]];
    //    commentModel.commentText = text;
    //    [messageModel.commentModelArray addObject:commentModel];
    //
    //    messageModel.shouldUpdateCache = YES;
    //    [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
    //    [self.chatKeyBoard keyboardDownForComment];
    //    self.chatKeyBoard.placeHolder = nil;
}
- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey{
    NSLog(@"%@",faceName);
}
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
}
- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"朋友圈";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.commentTableview];
    
    [self responData];
    
}
-(void)responData
{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *data =[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSDictionary *JSONDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *rowsDic in JSONDic[@"data"][@"rows"]) {
        MessageModel *messageModel = [MessageModel mj_objectWithKeyValues:rowsDic];
        [self.dataA addObject:messageModel];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
        cell.delegate = self;
    }
    
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    __weak __typeof(self) weakSelf= self;
    __weak __typeof(_commentTableview) weakTable= _commentTableview;
    __weak __typeof(window) weakWindow= window;
    
    __block MessageModel *model = [self.dataA objectAtIndex:indexPath.row];
    
    [cell configCellWithModel:model indexPath:indexPath];
    cell.backgroundColor =[UIColor whiteColor];
    //评论
    cell.CommentBtnClickBlock =^(UIButton *commentBtn,NSIndexPath *indexPath)
    {
        
        weakSelf.replayTheSeletedCellModel = nil;
        weakSelf.seletedCellHeight = 0.0;
        weakSelf.needUpdateOffset = YES;
        weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论 %@",model.userName];
        weakSelf.history_Y_offset = [commentBtn convertRect:commentBtn.bounds toView:weakWindow].origin.y;
        weakSelf.currentIndexPath = indexPath;
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    
    //更多
    cell.MoreBtnClickBlock = ^(UIButton *moreBtn,NSIndexPath * indexPath)
    {
        [weakSelf.chatKeyBoard keyboardDownForComment];
        weakSelf.chatKeyBoard.placeHolder = nil;
        model.isExpand = !model.isExpand;
        model.shouldUpdateCache = YES;
        [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    //点击九宫格
    cell.tapImageBlock = ^(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath){
        [weakSelf.chatKeyBoard keyboardDownForComment];
    };
    //点击文字
    cell.TapTextBlock=^(UILabel *desLabel){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:desLabel.text delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    };
    return cell;
}
#pragma mark - passCellHeightWithModel

- (void)passCellHeightWithMessageModel:(MessageModel *)messageModel commentModel:(CommentModel *)commentModel atCommentIndexPath:(NSIndexPath *)commentIndexPath cellHeight:(CGFloat )cellHeight commentCell:(CommentCell *)commentCell messageCell:(MessageCell *)messageCell{
    self.needUpdateOffset = YES;
    self.replayTheSeletedCellModel = commentModel;
    self.currentIndexPath = [self.commentTableview indexPathForCell:messageCell];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",commentModel.commentUserName];
    self.history_Y_offset = [commentCell.contentLabel convertRect:commentCell.contentLabel.bounds toView:window].origin.y;
    self.seletedCellHeight = cellHeight;
    [self.chatKeyBoard keyboardUpforComment];
}
- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath{
    model.shouldUpdateCache = YES;
    [self.commentTableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataA.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *messageModel = [self.dataA objectAtIndex:indexPath.row];
    CGFloat h = [MessageCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        MessageCell *cell = (MessageCell *)sourceCell;
        [cell configCellWithModel:messageModel indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : messageModel.cid,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(messageModel.shouldUpdateCache)};
        messageModel.shouldUpdateCache = NO;
        return cache;
    }];
    return h;
}
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat delta = 0.0;
    if (self.seletedCellHeight){//点击某行，进行回复某人
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-self.seletedCellHeight-kChatToolBarHeight);
    }else{//点击评论按钮
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-kChatToolBarHeight-24-10);//24为评论按钮高度，10为评论按钮上部的5加评论按钮下部的5
    }
    CGPoint offset = self.commentTableview.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    if (self.needUpdateOffset) {
        [self.commentTableview setContentOffset:offset animated:YES];
    }
    self.needUpdateOffset = NO;
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CommentViewController dealloc");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.chatKeyBoard keyboardDownForComment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"CommentViewController didReceiveMemoryWarning");
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.chatKeyBoard keyboardDownForComment];
}
-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}
-(UITableView *)commentTableview
{
    if (!_commentTableview) {
        _commentTableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, Device_Width, Device_Height -64) style:UITableViewStylePlain];
        _commentTableview.delegate = self;
        _commentTableview.dataSource = self;
        _commentTableview.tableFooterView =[UIView new];
        _commentTableview.showsHorizontalScrollIndicator = NO;
        _commentTableview.showsVerticalScrollIndicator = YES;
        [_commentTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndentifier];
        
    }
    return _commentTableview;
}
-(NSMutableArray *)dataA
{
    if (!_dataA) {
        _dataA =[NSMutableArray array];
        
    }
    return _dataA;
}

@end
