//
//  LeftViewController.m
//  SanMen
//
//  Created by lcc on 13-12-16.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "LeftViewController.h"
#import "MoveImgView.h"
#import "CCClientRequest.h"
#import "BroadPlayerViewController.h"
#import "ProgramObject.h"
#import "FMDBManage.h"

#define HOMEID @"5"

#define BTNCOUNT 21

@interface LeftViewController ()<MoveImgViewDelegate>
{
    CGPoint oldPoint;//保存点击前的未知
    CGPoint beginPoint;//开始位置
    BOOL isContain;//这个点是否包含在所点击的按钮上面
    UIPanGestureRecognizer *panGec;//长按手势
    MoveImgView *touchLastMoveBtn;
    MoveImgView *moveLastMoveBtn;
    BOOL isWobble;
    
    MoveImgView *tapLastMoveBtn;
}

@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UIButton *ui_saveBtn;
@property (strong, nonatomic) NSMutableArray *btnArrs;
@property (strong, nonatomic) CCClientRequest *request;
@property (strong, nonatomic) IBOutlet UIView *ui_view;

@end

@implementation LeftViewController

- (void)dealloc
{
    self.btnArrs = nil;
    self.request.c_delegate = nil;
    self.request = nil;
    self.ui_saveBtn = nil;
    self.ui_scrollView = nil;
    self.ui_view = nil;
    
    panGec = nil;
    touchLastMoveBtn = nil;
    moveLastMoveBtn = nil;
    tapLastMoveBtn = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //初始化网络
        self.request = [[CCClientRequest alloc] init];
        self.request.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置控件属性
    CGSize size = self.ui_scrollView.contentSize;
    size.height = viewHeight + 45;
    CGRect rect = self.ui_scrollView.frame;
    rect.size.height = viewHeight - 60;
    self.ui_scrollView.frame = rect;
    self.ui_scrollView.contentSize = size;
    self.ui_scrollView.clipsToBounds = NO;
    
    //保存按钮属性
    CGRect saveRect = self.ui_saveBtn.frame;
    saveRect.origin.y = viewHeight - saveRect.size.height;
    self.ui_saveBtn.frame = saveRect;
    //end
    
    //按钮读取和排序以及添加
    self.btnArrs = [[NSMutableArray alloc] init];
    self.btnArrs = [FMDBManage getDataFromTable:[ProgramObject class] WithString:@"1=1 order by p_tag asc"];
    //end
    
    //添加左边按钮
    [self addLeftProgramBtns];
    
    //过2.5秒钟后读取网络数据
    [self performSelector:@selector(requestBegin) withObject:nil afterDelay:2.5];
    
    CGRect viewRect = self.ui_view.frame;
    viewRect.size.height = viewHeight;
    self.ui_view.frame = viewRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
- (void) requestBegin
{
    //网络调用
    [self.request leftLanMu];
}

//判断点击的点在哪个按钮上
- (MoveImgView *) containInView:(CGPoint)point
{
    MoveImgView *retureView = nil;
    for (int i = 0; i < BTNCOUNT; i++)
    {
        MoveImgView *tmpView = (MoveImgView *)[self.view viewWithTag:i + 1];
        
        if (!tmpView)
        {
            break;
        }
        
        if (CGRectContainsPoint(tmpView.frame, point))
        {
            if (touchLastMoveBtn && touchLastMoveBtn.tag == tmpView.tag)
            {
                if (isWobble)
                {
                    continue;
                }
            }
            retureView = tmpView;
            break;
        }
    }
    
    return retureView;
}

//点击开始
- (void) touchBegin
{
    if (isWobble)
    {
        if (touchLastMoveBtn)
        {
            isContain = YES;
            [touchLastMoveBtn wobble:NO];
            //放大停止晃动
            [UIView animateWithDuration:0.3 animations:^{
                touchLastMoveBtn.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.0);
                touchLastMoveBtn.alpha = 0.4;
            }];
            
            oldPoint = touchLastMoveBtn.center;
        }
        else
        {
            isContain = NO;
        }
    }
}

//点击移动
- (void) touchMoveWithPoint:(CGPoint) point
{
    if (isContain)
    {
        float offsetX = point.x - beginPoint.x;
        float offsetY = point.y - beginPoint.y;
        touchLastMoveBtn.center = CGPointMake(offsetX + oldPoint.x, offsetY + oldPoint.y);
        [self setFrameAgain];
        
        //如果拖动的按钮跑出了屏幕
        if (touchLastMoveBtn.center.y > 370 && touchLastMoveBtn.center.y <= self.ui_scrollView.contentSize.height)
        {
            if (self.ui_scrollView.contentOffset.y != self.ui_scrollView.contentSize.height - self.ui_scrollView.frame.size.height)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.ui_scrollView.contentOffset = CGPointMake(0, self.ui_scrollView.contentSize.height - self.ui_scrollView.frame.size.height);
                    }];
            }
        }
        else if (touchLastMoveBtn.center.y < self.ui_scrollView.contentOffset.y)
        {
            if (self.ui_scrollView.contentOffset.y != 0)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.ui_scrollView.contentOffset = CGPointMake(0,0);
                }];
            }
            
        }
    }
}

//点击结束
- (void) touchEnd
{
    if (isContain)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [touchLastMoveBtn setCenter:CGPointMake(48 + 82*touchLastMoveBtn.columnIndex, 57 + 82*touchLastMoveBtn.rowIndex)];
                         }];
        [touchLastMoveBtn wobble:YES];
        touchLastMoveBtn.alpha = 1.0;
        touchLastMoveBtn = nil;
    }
}

//重新设定每个按钮的位置
- (void) setFrameAgain
{
    moveLastMoveBtn = [self containInView:touchLastMoveBtn.center];
    
    if (moveLastMoveBtn && moveLastMoveBtn.tag != touchLastMoveBtn.tag)
    {
        if (touchLastMoveBtn.tag < moveLastMoveBtn.tag)
        {
            //按钮向下拖动
            NSInteger startIndex = (touchLastMoveBtn.tag + 1);
            NSInteger endIndex = (moveLastMoveBtn.tag + 1);
            NSInteger rowIndex = moveLastMoveBtn.rowIndex;
            NSInteger columnIndex = moveLastMoveBtn.columnIndex;
            
            for (int x = startIndex; x < endIndex; x ++)
            {
                MoveImgView *tmpView = (MoveImgView *)[self.view viewWithTag:x];
                tmpView.tag = tmpView.tag - 1;
                
                if (tmpView.columnIndex == 0)
                {
                    tmpView.columnIndex = 2;
                    tmpView.rowIndex = tmpView.rowIndex - 1;
                }
                else
                {
                    tmpView.columnIndex = tmpView.columnIndex - 1;
                }
                
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     [tmpView setCenter:CGPointMake(48 + 82*tmpView.columnIndex, 57 + 82*tmpView.rowIndex)];
                                 }];
                
                
            }
            touchLastMoveBtn.tag = endIndex - 1;
            touchLastMoveBtn.columnIndex = columnIndex;
            touchLastMoveBtn.rowIndex = rowIndex;
        }
        else if (touchLastMoveBtn.tag > moveLastMoveBtn.tag)
        {
            //按钮向上拖动
            NSInteger startIndex = (touchLastMoveBtn.tag - 1);
            NSInteger endIndex = (moveLastMoveBtn.tag - 1);
            NSInteger rowIndex = moveLastMoveBtn.rowIndex;
            NSInteger columnIndex = moveLastMoveBtn.columnIndex;
            
            for (int x = startIndex; x > endIndex; x --)
            {
                MoveImgView *tmpView = (MoveImgView *)[self.view viewWithTag:x];
                tmpView.tag = tmpView.tag + 1;
                
                if (tmpView.columnIndex == 2)
                {
                    tmpView.columnIndex = 0;
                    tmpView.rowIndex = tmpView.rowIndex + 1;
                }
                else
                {
                    tmpView.columnIndex = tmpView.columnIndex + 1;
                }
                
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     [tmpView setCenter:CGPointMake(48 + 82*tmpView.columnIndex, 57 + 82*tmpView.rowIndex)];
                                 }];
            }
            
            touchLastMoveBtn.tag = endIndex + 1;
            touchLastMoveBtn.columnIndex = columnIndex;
            touchLastMoveBtn.rowIndex = rowIndex;
        }
    }
}

//添加长按手势
- (void) addLongPressGestureToImageView:(MoveImgView *) sender
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [sender addGestureRecognizer:longPressGestureRecognizer];
}

- (void) addLeftProgramBtns
{
    for (int x = 0; x < 7; x++)
    {
        for (int y = 0; y < 3; y++)
        {
            NSInteger index = x*3 + y + 1;
            
            if (index-1 >= [self.btnArrs count])
            {
                return;
            }
            
            ProgramObject *tmpObj = [self.btnArrs objectAtIndex: index - 1];
            
            MoveImgView *moveView = [[MoveImgView alloc] initWithFrame:CGRectMake(13 + 82*y, 22 + 82*x, 70, 70)];
            [self addLongPressGestureToImageView:moveView];
            moveView.tag = index;
            [moveView setM_delegate:self];
            
            moveView.rowIndex = x;
            moveView.columnIndex = y;
            moveView.p_imgUrl = tmpObj.p_imgUrl;
            [moveView setContentWithString:tmpObj.p_title];
            moveView.p_id = tmpObj.p_id;
            moveView.p_modelTyle = tmpObj.p_modelType;
            
            [moveView pressView:NO];
            [self.ui_scrollView addSubview:moveView];
            
            if ([moveView.p_id isEqualToString:HOMEID])
            {
                tapLastMoveBtn = moveView;
                [tapLastMoveBtn pressView:YES];
            }
        }
    }
}

#pragma mark -
#pragma mark - 按钮事件
- (IBAction)stopWobbleTapped:(id)sender
{
    if (isWobble)
    {
        for (int i = 0; i < BTNCOUNT; i++)
        {
            MoveImgView *tmpView = (MoveImgView *)[self.view viewWithTag:i + 1];
            if (!tmpView)
            {
                break;
            }

            [tmpView wobble:NO];
            tmpView.isWobble = NO;
            
            if (tapLastMoveBtn.tag != tmpView.tag)
            {
                [tmpView pressView:NO];
            }
            
            UILongPressGestureRecognizer *gesture = [tmpView.gestureRecognizers objectAtIndex:1];
            gesture.minimumPressDuration = 1.0f;
            
            for (ProgramObject *tmpObject in self.btnArrs)
            {
                if ([tmpObject.p_id isEqualToString:tmpView.p_id])
                {
                    tmpObject.p_tag = [NSString stringWithFormat:@"%d",tmpView.tag];
                    break;
                }
            }
        }
        
        isWobble = NO;
        isContain = NO;
    }
    
    self.ui_saveBtn.hidden = YES;
    
    //保存排序
    for (ProgramObject *tmpObj in self.btnArrs)
    {
        if (tmpObj.p_tag.length == 1)
        {
            tmpObj.p_tag = [NSString stringWithFormat:@"0%@",tmpObj.p_tag];
        }
        
        [FMDBManage updateTable:[ProgramObject class] setString:[NSString stringWithFormat:@"p_tag='%@'",tmpObj.p_tag] WithString:[NSString stringWithFormat:@"p_id='%@'",tmpObj.p_id]];
    }
    //end
}

#pragma mark -
#pragma mark - 长按手势 delegate
- (void) gestureRecognizerHandle:(UILongPressGestureRecognizer *) gesture
{
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            beginPoint = [gesture locationInView:self.ui_scrollView];
            touchLastMoveBtn = [self containInView:beginPoint];
            
            if (!isWobble)
            {
                for (int i = 0; i < BTNCOUNT; i++)
                {
                    MoveImgView *tmpView = (MoveImgView *)[self.view viewWithTag:i + 1];
                    if (!tmpView)
                    {
                        break;
                    }
                    tmpView.isWobble = YES;
                    [tmpView pressView:YES];
                    
                    [tmpView wobble:YES];
                    UILongPressGestureRecognizer *gesture = [tmpView.gestureRecognizers objectAtIndex:1];
                    gesture.minimumPressDuration = 0.0f;
                }
                
                self.ui_saveBtn.hidden = NO;
                
                isWobble = YES;
            }
            
            [self touchBegin];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.ui_scrollView];
            [self touchMoveWithPoint:point];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [self touchEnd];
        }
            break;
            
        default:
            break;
    }
}

//点击图片代理
- (void) moveImgViewTapped:(MoveImgView *)tapMoveImg
{
    //切换度图片
    if (touchLastMoveBtn)
    {
        [touchLastMoveBtn pressView:NO];
    }
    
    if (tapLastMoveBtn)
    {
        [tapLastMoveBtn pressView:NO];
    }
    
    touchLastMoveBtn = (MoveImgView *)[self.ui_scrollView viewWithTag:tapMoveImg.tag];
    [touchLastMoveBtn pressView:YES];
    
    tapLastMoveBtn = touchLastMoveBtn;
    
    
    NSString *nameString = tapMoveImg.p_title;
    SMApp.newsType = tapMoveImg.p_modelTyle;
    SMApp.newsTypeName = nameString;
    switch ([tapMoveImg.p_modelTyle integerValue])
    {
        case PHOME://首页
            [super setCenterVCWithString:@"HomeViewController" object:nameString];
            break;
        case PNEWS://新闻
            [super setCenterVCWithString:@"NewsViewController" object:nameString];
            break;
        case PPUBLISH://发布
            [super setCenterVCWithString:@"PublishMSGViewController" object:nameString];
            break;
        case PLOCATIONNEWS://县情
            [super setCenterVCWithString:@"LocalNewsViewController" object:nameString];
            break;
        case PACTIVITY://活动
            [super setCenterVCWithString:@"ActivityListViewController" object:nameString];
            break;
        case PZHENGWU://政务
            [super setCenterVCWithString:@"ZhengWuViewController" object:nameString];
            break;
        case PFOOD://美食
            [super setCenterVCWithString:@"FoodViewController" object:nameString];
            break;
        case PPAIKE://拍客
            [super setCenterVCWithString:@"PaiKeViewController" object:nameString];
            break;
        case PBROADPLAYER://广播
        {
            BroadPlayerViewController *broadPlayer = [[BroadPlayerViewController alloc] init];
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.nav pushViewController:broadPlayer];
        }
            break;
        case MOVIECENEMA://影院
            [super setCenterVCWithString:@"MovieListViewController" object:nameString];
            
            break;
        case THEMEPRO://专栏
            [super setCenterVCWithString:@"ThemeHomeViewController" object:nameString];
            break;
            
        case READBOOK://阅读
            [super setCenterVCWithString:@"BookHomeViewController" object:nameString];
            break;
            
        case CONVINIENTPEOPLE://便民
            [super setCenterVCWithString:@"ConvinientHomeViewController" object:nameString];
            break;
            
        case AROUNDME://周边
            [super setCenterVCWithString:@"AboundMeViewController" object:nameString];
            break;
            
        case OPENPOWER://权利公开
            [super setCenterVCWithString:@"PowerOpenWapViewController" object:nameString];
            break;
            
        case LEFTZHONGGUOWANGSHI://中国网事
            [super setCenterVCWithString:@"WorldViewController" object:nameString];
            break;
            
        default:
            break;
    }
    
}

//网络数据请求返回数据回调
- (void) leftLanMuCallBack:(id) objectData
{
    if ([self.btnArrs count] == 0)
    {
        
        self.btnArrs = objectData;
        [self addLeftProgramBtns];
        
    }
    
}

@end
