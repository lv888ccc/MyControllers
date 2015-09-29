//
//  AboundMeViewController.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "AboundMeViewController.h"
#import "AroundMapViewController.h"

#define HistoryKey @"history"

@interface AboundMeViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UIView *ui_historyView;
@property (strong, nonatomic) IBOutlet UITextField *ui_textField;
@property (strong, nonatomic) NSMutableArray *keyArr;
@property (strong, nonatomic) IBOutlet UIButton *ui_searchBtn;

@end

@implementation AboundMeViewController

- (void)dealloc
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.keyArr forKey:HistoryKey];
    
    self.ui_scrollView = nil;
    self.ui_historyView = nil;
    self.ui_textField = nil;
    self.keyArr = nil;
    self.ui_searchBtn = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.ui_scrollView.contentSize = CGSizeMake(320, 580);
    self.ui_scrollView.showsVerticalScrollIndicator = NO;

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *tmpArr = [user objectForKey:HistoryKey];
    
    self.keyArr = [[NSMutableArray alloc] init];
    if (tmpArr)
    {
        [self.keyArr addObjectsFromArray:tmpArr];
    }
    
    [self addHistoryKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom delegate
- (void)addHistoryKey
{
    for (UIView *tmpView in self.ui_historyView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    CGRect rect = self.ui_historyView.frame;
    
    if (self.keyArr.count > 0)
    {
        rect.size.height = 45*(self.keyArr.count + 1);
        for (int i = 0; i < [self.keyArr count];i ++)
        {
            UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpBtn setTitle:[self.keyArr objectAtIndex:i] forState:UIControlStateNormal];
            [tmpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [tmpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            tmpBtn.frame = CGRectMake(45, i*45, 236, 45);
            [tmpBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self.ui_historyView addSubview:tmpBtn];
            [tmpBtn addTarget:self action:@selector(keyTapped:) forControlEvents:UIControlEventTouchUpInside];
            tmpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            UIImageView *signImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15+i*45, 15, 15)];
            [signImgView setImage:[UIImage imageNamed:@"search_history"]];
            [self.ui_historyView addSubview:signImgView];
            
            UIImageView *sImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44+45*i, 263, 1)];
            [sImgView setBackgroundColor:[UIColor lightGrayColor]];
            [self.ui_historyView addSubview:sImgView];
            sImgView.alpha = 0.5;
        }
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        clearBtn.frame = CGRectMake(0, 45*[self.keyArr count], 296, 45);
        [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.ui_historyView addSubview:clearBtn];
        [clearBtn addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        rect.size.height = 45;
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setTitle:@"暂无搜索记录" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        clearBtn.frame = CGRectMake(0, 0, 296, 45);
        [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.ui_historyView addSubview:clearBtn];
    }
    
    
    
    self.ui_historyView.frame = rect;
    
    
}

- (void) addKeyWithString:(NSString *) keyString
{
    if ([self.keyArr containsObject:keyString])
    {
        [self.keyArr removeObject:keyString];
    }
    
    [self.keyArr insertObject:keyString atIndex:0];
    
    if (self.keyArr.count == 6)
    {
        [self.keyArr removeLastObject];
    }
}

//禁用发送按钮
- (void) setBtnEnable
{
    if ([[self.ui_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        self.ui_searchBtn.enabled = NO;
        [self.ui_searchBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        self.ui_searchBtn.enabled = YES;
        [self.ui_searchBtn setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:137.0f/255.0f blue:217.0f/255.0f alpha:1.0f]];
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)searchTapped:(id)sender
{
    [self.ui_textField resignFirstResponder];
    [self addKeyWithString:self.ui_textField.text];
    [self addHistoryKey];
    
    AroundMapViewController *aroud = [[AroundMapViewController alloc] init];
    aroud.keyString = self.ui_textField.text;
    [SMApp.nav pushViewController:aroud];
}

- (IBAction)keyTapped:(id)sender
{
    [self.ui_textField resignFirstResponder];
    UIButton *tmpBtn = (UIButton *)sender;
    [self addKeyWithString:tmpBtn.titleLabel.text];
    [self addHistoryKey];
    
    AroundMapViewController *aroud = [[AroundMapViewController alloc] init];
    aroud.keyString = tmpBtn.titleLabel.text;
    [SMApp.nav pushViewController:aroud];
}

- (void) clearHistory:(id)sender
{
    [self.keyArr removeAllObjects];
    [self addHistoryKey];
}



#pragma mark -
#pragma mark - text field
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.ui_textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(setBtnEnable) withObject:nil afterDelay:0.3];
    return YES;
}

@end
