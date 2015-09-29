//
//  MyTableView.h
//  Cc_TableView
//
//  Created by mmc on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

//下拉重新加载调用的数据协议
@protocol MyTableViewDelegate <NSObject>

@optional
//加载数据
- (void) myTableViewLoadDataAgain;
//加载行高
- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath;
//点击代理事件
- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//取消选择
- (void) myTabledidDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
//加载更多
- (void) myTableLoadMore;
//上滚动
- (void) scrollUp;
//下滚动
- (void) scrollDown;
//滚动中
- (void) scrolling;
//编辑删除
- (NSString *) myTableDelBtnTitle;
//提交删除
- (void) myTableCommitDelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyTableView : UITableView<EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    //控制加载更多是否显示
    BOOL footerViewIsVisible;
}

//是否显示下拉刷新
@property (nonatomic) BOOL isFresh;
//将单击事件传出来
@property (weak) id<MyTableViewDelegate> myTable_delegate;
//数据源
@property (nonatomic, retain) NSMutableArray *tableData;
//记录表的cell
@property (nonatomic, retain) NSString *cellNameString;
//用于传递代理方法
@property (weak) id cellDelegateObject;

//判断是否是图集
@property (nonatomic) BOOL isImage;
@property (nonatomic) NSInteger clumnCount;

//编辑
@property (nonatomic) BOOL isEdit;
//编辑类型
@property (nonatomic) BOOL isMultiSelect;

//数据加载完成
- (void) doneLoadingTableViewData;
//是否有下拉刷新
- (void) setfreshHeaderView:(BOOL) isFresh;
//下拉动画
- (void) dragAnimation;
//重新加载数据
- (void)reloadTableViewDataSource;
//设置加载更多的状态
- (void) setLoadingStatus:(BOOL) isLoading;
//设置加载更多是否显示
- (void) setFooterViewHidden:(BOOL) hidden;

@end

