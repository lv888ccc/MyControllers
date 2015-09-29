//
//  ThemePaiKeDetailViewController.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "ThemePaiKeDetailViewController.h"
#import "PaiKeUploadViewController.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "PaiKeContentDetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "CamaraObject.h"
#import "UIImage+Ext.h"
#import "CCClientRequest.h"
#import "PaiKeObject.h"
#import "StatusTipView.h"

UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo);

typedef enum {
    
    FINISH,
    LAODING,
    ALLDATA
    
} DATASTATUS;

@interface ThemePaiKeDetailViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    BOOL isOpen;
    
    //相机操作
    CamaraObject *camaraObj;
    
    NSInteger pageIndex;
    DATASTATUS loadingStatus;//是否处于加载状态
    
    CGPoint beginPoint;
    
    NSInteger photoType;
}

@property (strong, nonatomic) NSMutableArray *tableData;
@property (nonatomic, retain) TMQuiltView *quiltView;
@property (strong, nonatomic) NSString *fileString;

@property (strong, nonatomic) IBOutlet UIView *ui_sheetView;
@property (strong, nonatomic) IBOutlet UIButton *ui_markBtn;
@property (strong, nonatomic) IBOutlet UIView *ui_headerView;
@property (strong, nonatomic) IBOutlet UIButton *ui_uploadBtn;


@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ui_loadingMoreActivity;
@property (strong, nonatomic) IBOutlet UILabel *ui_moreTipLabel;

@end

@implementation ThemePaiKeDetailViewController

- (void)dealloc
{
    self.quiltView.delegate = nil;
    self.quiltView = nil;
    self.tableData = nil;
    
    self.fileString = nil;
    self.ui_uploadBtn = nil;
    self.ui_markBtn = nil;
    self.ui_sheetView = nil;
    _refreshHeaderView = nil;
    camaraObj = nil;
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.ui_freshTipLabel = nil;
    self.tipView = nil;
    
    self.pId = nil;
    
    self.ui_headerView = nil;
    self.ui_loadingMoreActivity = nil;
    
    self.ui_moreTipLabel = nil;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //数据初始化
    self.tableData = [[NSMutableArray alloc] init];
    
    //初始化界面
    [self initViewController];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isOpen = NO;
    [StatusBarObject setStatusBarStyleWithIndex:0];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (isOpen == NO)
    {
        [StatusBarObject setStatusBarStyleWithIndex:1];
    }
    
}

#pragma mark -
#pragma mark - custom method
- (void) initViewController
{
    self.ui_freshTipLabel.hidden = YES;
    self.view.clipsToBounds = YES;
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    //相机
    camaraObj = [[CamaraObject alloc] init];
    camaraObj.c_delegate = self;
    //end
    
    self.ui_loadingMoreActivity.hidden = YES;
    self.ui_moreTipLabel.hidden = YES;
    
    //瀑布流
    self.quiltView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 124, 320, viewHeight - 64)];
    self.quiltView.delegate = self;
    self.quiltView.dataSource = self;
    [self.view addSubview:self.quiltView];
    self.quiltView.clipsToBounds = NO;
    [self.quiltView addSubview:self.ui_loadingMoreActivity];
    [self.quiltView addSubview:self.ui_moreTipLabel];
    [self.view bringSubviewToFront:self.ui_headerView];
    //end
    
    //添加下拉刷新
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -60, 320, 60)];
    view.delegate = self;
    [self.quiltView addSubview:view];
    _refreshHeaderView = view;
    [view customSetState:EGOOPullRefreshLoading];
    //end
    
    //sheet表单
    [SMApp.nav.view addSubview:self.ui_sheetView];
    [SMApp.nav.view addSubview:self.ui_markBtn];
    
    CGRect rect = self.ui_sheetView.frame;
    rect.origin.y = viewHeight;
    self.ui_sheetView.frame = rect;
    
    [SMApp.nav.view bringSubviewToFront:self.ui_markBtn];
    [SMApp.nav.view bringSubviewToFront:self.ui_sheetView];
    //end
    
    //网络数据请求
    [self reloadData];
    //end
    
    [self performSelector:@selector(camaraCome) withObject:nil afterDelay:0.5];
}

//动态显示点击相机按钮
- (void) camaraCome
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.ui_uploadBtn.frame;
        rect.origin.x = 245;
        self.ui_uploadBtn.frame = rect;
    }];
    
    [self.view bringSubviewToFront:self.ui_uploadBtn];
}

//上下滚动变大小窗体
- (void) scrollUpDown
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.quiltView.frame;
        CGRect viewRect = self.view.frame;
        viewRect.size.height = self.view.superview.frame.size.height;
        rect.size.height = self.view.superview.frame.size.height;
        self.quiltView.frame = rect;
        self.view.frame = viewRect;
    }];
}

//打开相机
- (void) openUpload:(id) sender
{
    PaiKeUploadViewController *upload = [[PaiKeUploadViewController alloc] init];
    upload.isLight = NO;
    [upload addImgObjWith:sender];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:upload];
    isOpen = YES;
}

- (void) saveToLocalWithImg:(UIImage *) image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [imageData writeToFile:self.fileString atomically:NO];
}

//完成数据加载
- (void) finishLoading
{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = self.quiltView.frame;
        rect.origin.y = 64;
        self.quiltView.frame = rect;
    } completion:^(BOOL finished) {
        [_refreshHeaderView customSetState:EGOOPullRefreshNormal];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.quiltView];
        loadingStatus = FINISH;
    }];
}

//下拉动画
- (void) dragAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = self.quiltView.frame;
        rect.origin.y = 60;
        self.quiltView.frame = rect;
    }];
}

//开始加载
- (void) reloadData
{
    pageIndex = 1;
    loadingStatus = LAODING;
    [self.myRequest paikeThemeDetailWithPageNo:pageIndex pId:self.pId];
}

//加载更多
- (void) loadMoreData
{
    self.ui_loadingMoreActivity.hidden = NO;
    pageIndex ++;
    loadingStatus = LAODING;
    [self.myRequest paikeThemeDetailWithPageNo:pageIndex pId:self.pId];
}

//瀑布流添加加载更多
- (void) loadMoreViewAnimationWithArr:(NSMutableArray *) arr
{
    if ([arr count] >= PAGESIZE)
    {
        CGRect rect = self.ui_loadingMoreActivity.frame;
        rect.origin.y = self.quiltView.contentSize.height - 30;
        self.ui_loadingMoreActivity.frame = rect;
//        self.ui_moreTipLabel.hidden = YES;
    }
    else
    {
        CGRect rect = self.ui_moreTipLabel.frame;
        rect.origin.y = self.quiltView.contentSize.height - 50;
        self.ui_moreTipLabel.frame = rect;
        if (pageIndex != 1)
        {
            self.ui_moreTipLabel.hidden = NO;
        }
        loadingStatus = ALLDATA;
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)freshTapped:(id)sender
{
    self.ui_freshTipLabel.hidden = YES;
    self.quiltView.hidden = NO;
    
    [_refreshHeaderView customSetState:EGOOPullRefreshLoading];
    [self dragAnimation];
    [self reloadData];
}

- (IBAction)uploadTapped:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         CGRect rect = self.ui_sheetView.frame;
                         rect.origin.y = viewHeight - rect.size.height;
                         self.ui_sheetView.frame = rect;
                         self.ui_markBtn.alpha = 0.5;
                         
                         CGRect rectU = self.ui_uploadBtn.frame;
                         rectU.origin.x = 320;
                         self.ui_uploadBtn.frame = rectU;
                         
                     }];
}

- (IBAction)openCamaraTapped:(id)sender
{
    photoType = 1;
    [camaraObj openPicOrVideoWithSign:photoType];
    isOpen = YES;
    [self markTapped:nil];
}

- (IBAction)selectTapped:(id)sender
{
    photoType = 0;
    [camaraObj openPicOrVideoWithSign:photoType];
    isOpen = YES;
    [StatusBarObject setStatusBarStyleWithIndex:0];
    [self markTapped:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [self markTapped:nil];
}

- (IBAction)markTapped:(id)sender
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect rect = self.ui_sheetView.frame;
                         rect.origin.y = viewHeight;
                         self.ui_sheetView.frame = rect;
                         self.ui_markBtn.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self camaraCome];
                     }];
}

- (void)guidTapped:(UIButton *)sender
{
    __block UIButton *tmpBtn = sender;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.ui_uploadBtn.frame;
        rect.origin.x = 245;
        self.ui_uploadBtn.frame = rect;
        
        tmpBtn.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        [tmpBtn removeFromSuperview];
        tmpBtn = nil;
    }];
}

#pragma mark -
#pragma mark - 瀑布流代理
- (NSArray *)images
{
    return self.tableData;
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath
{
    PaiKeObject *tmpObj = (PaiKeObject *)[self.images objectAtIndex:indexPath.row];
    UIImageView *tmpImageView = [[UIImageView alloc] init];
    [tmpImageView setImageWithURL:[NSURL URLWithString:tmpObj.p_imgUrl] placeholderImage:[[UIImage imageNamed:@"flow_place"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    
    return tmpImageView.image;
}

#pragma mark -
#pragma mark - TMQuiltViewDelegate
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    NSInteger count = [self.images count];
    return count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell)
    {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    PaiKeObject *tmpObj = (PaiKeObject *)[self.images objectAtIndex:indexPath.row];
    [cell.photoView setImageWithURL:[NSURL URLWithString:tmpObj.p_imgUrl] placeholderImage:[[UIImage imageNamed:@"flow_place"] stretchableImageWithLeftCapWidth:0 topCapHeight:20]];
    cell.titleLabel.text = [NSString stringWithFormat:@" %@",tmpObj.p_title];
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 2;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    PaiKeObject *tmpObj = (PaiKeObject *)[self.images objectAtIndex:indexPath.row];
    CGFloat tmpHegiht = [tmpObj.p_height floatValue];
    CGFloat tmpWidth = [tmpObj.p_width floatValue];
    
    return tmpHegiht * 145/tmpWidth;
}

- (void) quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    PaiKeObject *tmpObj = [self.tableData objectAtIndex:indexPath.row];
    PaiKeContentDetailViewController *contentDetail = [[PaiKeContentDetailViewController alloc] init];
    contentDetail.pId = tmpObj.p_id;
    contentDetail.isLight = YES;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:contentDetail];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadData];
}

// should return if data source model is reloading
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading;
}

// should return date data source was last changed
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    beginPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (self.quiltView.contentOffset.y >= (self.quiltView.contentSize.height-self.quiltView.frame.size.height))
    {
        if (loadingStatus == FINISH && [self.tableData count] >= PAGESIZE)
        {
            [self loadMoreData];
        }
    }
    
    if (scrollView.contentOffset.y - beginPoint.y >= 6 && self.ui_uploadBtn.frame.origin.x == 245)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = self.ui_uploadBtn.frame;
            rect.origin.x = 320;
            self.ui_uploadBtn.frame = rect;
        }];

    }
    
    if (scrollView.contentOffset.y - beginPoint.y <= -10 && self.ui_uploadBtn.frame.origin.x == 320)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = self.ui_uploadBtn.frame;
            rect.origin.x = 245;
            self.ui_uploadBtn.frame = rect;
        }];
        

    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        
        UIImage  *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (photoType == 1)
        {
            UIImageWriteToSavedPhotosAlbum(img,nil, nil, nil);
        }
        
        //缩减图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = img;
        CGSize imgSize = [imageView image].size;
        if (imgSize.width > 640)
        {
            img = [UIImage imageWithImage:img scaledToSize:CGSizeMake(640.0f, imgSize.height*(640.0f/imgSize.width))];
            imgSize.height = imgSize.height*(640.0f/imgSize.width);
            imgSize.width = 640.0f;
        }
        [infoDic setValue:[NSString stringWithFormat:@"%.0f",imgSize.width] forKey:@"Width"];
        [infoDic setValue:[NSString stringWithFormat:@"%.0f",imgSize.height] forKey:@"Height"];
        //end
        
        
        UIImage *image = [img shrinkImage:CGSizeMake(70, 70)];
        
        //图片名字
        //用当前时间保证文件名称唯一...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        
        //本地路径
        NSString *imagePath = [NSString stringWithFormat:@"%@%@.jpg",PicPath,strDate];
        self.fileString = imagePath;
        
        [infoDic setValue:imagePath forKey:@"localPath"];
        [infoDic setValue:[NSString stringWithFormat:@"%@.jpg",strDate] forKey:@"name"];
        [infoDic setValue:image forKey:@"image"];
        
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        strDate = [dateFormatter stringFromDate:[NSDate date]];
        [infoDic setValue:strDate forKey:@"datetime"];
        
        [self performSelectorInBackground:@selector(saveToLocalWithImg:) withObject:img];
    }
    
    [self performSelector:@selector(openUpload:) withObject:infoDic afterDelay:0.3];
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) paikeThemeDetailCallBack:(id) objectData
{
    [self finishLoading];
    
    NSMutableArray *tmpArr = objectData;
    
    if (pageIndex == 1)
    {
        [self.tableData removeAllObjects];
    }
    else
    {
        self.ui_loadingMoreActivity.hidden = YES;
    }
    
    [self.tableData addObjectsFromArray:tmpArr];
    [self.quiltView reloadData];
    
    [self performSelector:@selector(loadMoreViewAnimationWithArr:) withObject:tmpArr afterDelay:0.1];
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    [self finishLoading];
    if (reasonString)
    {
        if ([self.tableData count] == 0)
        {
            self.quiltView.hidden = YES;
            self.ui_freshTipLabel.hidden = NO;
        }
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
    }
}

@end
