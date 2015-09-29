//
//  ScrollImagesBrowseViewController.m
//  WuXianQingDao
//
//  Created by lcc on 13-12-7.
//
//

#import "ScrollImagesBrowseViewController.h"
#import "ImageScaleAndSlip.h"
#import "CCClientRequest.h"
#import "PaiKeObject.h"

UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo);

@interface ScrollImagesBrowseViewController ()<UIScrollViewDelegate,SDImageCacheDelegate>
{
    NSInteger imgPageIndex;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CCClientRequest *myRequest;
@property (strong, nonatomic) IBOutlet UIView *ui_view;
@property (strong, nonatomic) IBOutlet UILabel *ui_indexLabel;
@property (strong, nonatomic) IBOutlet UIButton *ui_downloadBtn;
@property (strong, nonatomic) IBOutlet UIView *ui_tipView;
@property (strong, nonatomic) IBOutlet UIButton *ui_backBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_defaultBtn;

@end

@implementation ScrollImagesBrowseViewController

- (void)dealloc
{
    self.scrollView = nil;
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.pId = nil;
    self.imgsArr = nil;
    self.ui_view = nil;
    self.ui_tipView = nil;
    self.ui_backBtn = nil;
    self.ui_defaultBtn = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//只支持portait,不能旋转:
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
    
    //属性设置 scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 340, viewHeight)];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    [self.view bringSubviewToFront:self.ui_view];
    self.ui_downloadBtn.hidden = YES;
    self.ui_indexLabel.hidden = YES;
    [self.view bringSubviewToFront:self.ui_downloadBtn];
    [self.view bringSubviewToFront:self.ui_indexLabel];
    [self.view bringSubviewToFront:self.ui_backBtn];
    //end
    
    imgPageIndex = 0;
    
    if (self.urlString == nil)
    {
        //网络数据请求
        [self reloadData];
        //end
    }
    else
    {
        self.ui_downloadBtn.hidden = NO;
        self.ui_indexLabel.hidden = NO;
        self.ui_indexLabel.text = @"1/1";
        ImageScaleAndSlip *ascrView = [[ImageScaleAndSlip alloc] initWithFrame:CGRectMake(0, 0, 320, self.scrollView.frame.size.height)];
        
        ascrView.imagePath = self.urlString;
        ascrView.tag = 1000;
        
        [self.scrollView addSubview:ascrView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:1];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:0];
}


#pragma mrak -
#pragma mark - custom method
//网络数据请求
- (void) reloadData
{
    [self.myRequest paikeImgDetailWithPid:self.pId];
}

//让提示语消失
- (void) tipDispear
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.ui_tipView.frame;
        rect.origin.x = 320;
        self.ui_tipView.frame = rect;
    }];
}

#pragma mark -
#pragma mark - 按钮单击
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    imgPageIndex = page;
    
    self.ui_indexLabel.text = [NSString stringWithFormat:@"%d/%d",page + 1,[self.imgsArr count]];
}

- (IBAction)backTapped:(id)sender
{
    [SMApp.nav popViewController];
}

- (IBAction)saveTapped:(id)sender
{
    [self.view bringSubviewToFront:self.ui_tipView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.ui_tipView.frame;
        rect.origin.x = 200;
        self.ui_tipView.frame = rect;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(tipDispear) withObject:nil afterDelay:1];
    }];
    
    ImageScaleAndSlip *ascrView = (ImageScaleAndSlip *)[self.scrollView viewWithTag:imgPageIndex + 1000];
    UIImageWriteToSavedPhotosAlbum(ascrView.imageView.image,nil, nil, nil);
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) paikeImgDetailCallBack:(id) objectData
{
    NSMutableArray *tmpArr = (NSMutableArray *)objectData;
    self.imgsArr = tmpArr;
    if ([tmpArr count] > 0)
    {
        self.scrollView.hidden = NO;
        NSInteger imgCount = [tmpArr count];
        
        self.ui_indexLabel.text = [NSString stringWithFormat:@"1/%d",imgCount];
    

        for (int i = 0 ; i < imgCount; i ++)
        {
            
            ImageScaleAndSlip *ascrView = [[ImageScaleAndSlip alloc] initWithFrame:CGRectMake(340*i, 0, 320, self.scrollView.frame.size.height)];
            
            PaiKeObject *tmpObj = [tmpArr objectAtIndex:i];
            
            ascrView.imagePath = tmpObj.p_imgUrl;
            ascrView.tag = 1000+i;
            
            [self.scrollView addSubview:ascrView];
        }
        
        CGSize size = self.scrollView.contentSize;
        size.width = 340*imgCount;
        [self.scrollView setContentSize:size];
        
        self.ui_downloadBtn.hidden = NO;
        self.ui_indexLabel.hidden = NO;
        
        [self.view bringSubviewToFront:self.ui_downloadBtn];
        [self.view bringSubviewToFront:self.ui_indexLabel];
        self.ui_defaultBtn.hidden = YES;
    }
    else
    {
        self.scrollView.hidden = YES;
    }
    
}

@end
