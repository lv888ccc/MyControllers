//
//  AroundMapViewController.m
//  SanMen
//
//  Created by lcc on 14-2-15.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "AroundMapViewController.h"
#import "BMKMapView.h"
#import "StatusTipView.h"

@interface AroundMapViewController ()<BMKMapViewDelegate, BMKSearchDelegate>
{
    CLLocationCoordinate2D myLocation;
    BOOL flag;
    BOOL isLoaction;
}

@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;
@property (strong, nonatomic) BMKSearch *search;
@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation AroundMapViewController

- (void)dealloc
{
    self.ui_titleLabel = nil;
    self.search = nil;
    self.mapView = nil;
    self.tipView = nil;
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
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, 320, viewHeight - 64)];
    self.search = [[BMKSearch alloc] init];
    
    [self.mapView setZoomLevel:13];
    self.mapView.isSelectedAnnotationViewFront = YES;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
    flag = YES;
    isLoaction = NO;
    
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:0];
    
    self.ui_titleLabel.text = self.keyString;
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //移除手势
    [self performSelector:@selector(removeRecognizer) withObject:nil afterDelay:0.5];
    
    [self.view bringSubviewToFront:self.tipView];
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Searching isHidden:NO];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:1];
    
    //停止定位
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = NO;
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.search.delegate = nil; // 不用时，置nil
}

#pragma mark -
#pragma mark - custom method
- (void) removeRecognizer
{
    [SMApp.nav removeRecognizer];
    self.mapView.showsUserLocation = YES;
}

- (void) searchBegin
{
    flag = [self.search poiSearchNearBy:self.keyString center:myLocation radius:2500 pageIndex:0];
	if (flag)
    {
		NSLog(@"search success.");
	}
    else
    {
        NSLog(@"search failed!");
    }
}

-(void)recenterMap
{
	NSArray *coordinates=[self.mapView valueForKeyPath:@"annotations.coordinate"];
	CLLocationCoordinate2D maxCoord={-90.0f,-180.0f};
	CLLocationCoordinate2D minCoord={90.0f,180.0f};
	for (NSValue *value in coordinates) {
		CLLocationCoordinate2D coord={0.0f,0.0f};
		[value getValue:&coord];
		if (coord.longitude>maxCoord.longitude) {
			maxCoord.longitude=coord.longitude;
		}
		if(coord.latitude>maxCoord.latitude){
			maxCoord.latitude=coord.latitude;
		}
		if (coord.longitude<minCoord.longitude) {
			minCoord.longitude=coord.longitude;
		}
		if(coord.latitude<minCoord.latitude){
			minCoord.latitude=coord.latitude;
		}
	}
	BMKCoordinateRegion region={{0.0f,0.0f},{0.0f,0.0f}};
	region.center.longitude=(minCoord.longitude+maxCoord.longitude)/2.0;
	region.center.latitude=(minCoord.latitude+maxCoord.latitude)/2.0;
	region.span.longitudeDelta=maxCoord.longitude-minCoord.longitude;
	region.span.latitudeDelta=maxCoord.latitude-minCoord.latitude;
	[self.mapView setRegion:region animated:NO];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    [SMApp.nav popViewController];
}

- (IBAction)freshTapped:(id)sender
{
    [self searchBegin];
    [self.view bringSubviewToFront:self.tipView];
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Searching isHidden:NO];
}

- (IBAction)locationTapped:(id)sender
{
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = NO;
    
    [self performSelector:@selector(removeRecognizer) withObject:nil afterDelay:0.5];
    isLoaction = NO;
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
	
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil)
    {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
	
    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark - 用户定位
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil)
    {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
        myLocation = userLocation.location.coordinate;
        
        if (flag == YES)
        {
            [self searchBegin];
            flag = NO;
        }
        
        if (isLoaction == NO)
        {
            [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:NO];
            isLoaction = YES;
        }
        
	}
	
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    if (error == BMKErrorOk)
    {
        
        
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
        
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:[NSString stringWithFormat:@"得到%d个结果",result.poiInfoList.count] isHidden:YES];
        
		for (int i = 0; i < result.poiInfoList.count; i++)
        {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
		}
        
        if (result.poiInfoList.count > 0)
        {
            [self recenterMap];
        }
        
	}
    else if (error == BMKErrorRouteAddr)
    {
        NSLog(@"起始点有歧义");
    }
    else
    {
        [self.tipView tipShowWithType:DataIsNullTip tipString:[NSString stringWithFormat:@"周边没有%@",self.keyString] isHidden:YES];
    }
}

@end
