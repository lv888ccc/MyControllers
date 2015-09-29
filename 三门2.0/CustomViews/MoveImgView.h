//
//  MoveImgView.h
//  DragButtonDemo
//
//  Created by lcc on 13-12-13.
//
//

#import <UIKit/UIKit.h>

@protocol MoveImgViewDelegate;

@interface MoveImgView : UIImageView

@property (nonatomic) BOOL isWobble;

@property (weak) id<MoveImgViewDelegate> m_delegate;

@property (nonatomic) NSInteger rowIndex;
@property (nonatomic) NSInteger columnIndex;
@property (nonatomic, strong) NSString *p_id;
@property (nonatomic, strong) NSString *p_modelTyle;
@property (nonatomic, strong) NSString *p_title;
@property (nonatomic, strong) NSString *p_imgUrl;

//晃动
- (void)wobble:(BOOL)wobble;
//切换图片
- (void) pressView:(BOOL) isPress;

- (void) setContentWithString:(NSString *) titleString;

@end

@protocol MoveImgViewDelegate <NSObject>

- (void) moveImgViewTapped:(MoveImgView *)tapMoveImg;

@end