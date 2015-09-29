//
//  NumberLabel.m
//
//  Created by cc on 15/9/28.
//  Copyright (c) 2015年 cc. All rights reserved.
//
#import "NumberLabel.h"

#define UpdateCount 20
#define UpdateInputInterval 1.0f/(float)UpdateCount

@interface NumberLabel ()
@property (nonatomic, strong) NSTimer *amountUpdateTimer;
@property (nonatomic, assign) int     currentCount;
@property (nonatomic, assign) double  from;
@property (nonatomic, assign) double  value;
@property (nonatomic, assign) BOOL    hideFraction;
@end

@implementation NumberLabel

- (instancetype) initWithFrame:(CGRect)frame hideFraction:(BOOL) hideFraction
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsFontSizeToFitWidth = YES;
        self.hideFraction = hideFraction;
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame hideFraction:NO];
}

- (void) setNumber:(double)num animated:(BOOL) animated
{
    if (animated) {
        double oldValue = num * 0.80;
        [self animateFrom:oldValue to:num];
    } else {
        self.text = [self formatAmount:[NSNumber numberWithDouble:num]];
        _value = num;
    }
}

- (void)animateFrom:(double)from to:(double) to
{
    if (_amountUpdateTimer != nil) {
        [_amountUpdateTimer invalidate];
        _amountUpdateTimer = nil;
    }
    
    _from = from;
    _value = to;
    _currentCount = 0;
    _amountUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:UpdateInputInterval target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer *)timer
{   
    if (_currentCount > UpdateCount) {
        if (_amountUpdateTimer != nil) {
            [_amountUpdateTimer invalidate];
            _amountUpdateTimer = nil;
        }
        self.text = [self formatAmount:[NSNumber numberWithDouble:_value]];
        return;
    }
    double input = UpdateInputInterval * _currentCount;
    double factor = [self getNumberFromInput:(input)];
    self.text = [self formatAmount: [NSNumber numberWithDouble:( _from + (_value - _from) * factor)]];
    _currentCount++;
}

- (NSString *)formatAmount:(NSNumber *)amount
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencySymbol:@""];
    NSString *amountStr =  [currencyFormatter stringFromNumber:@([amount doubleValue])];
    if (_hideFraction) {
        NSUInteger index = [amountStr rangeOfString:@"."].location;
        if (index < [amountStr length])
            amountStr = [amountStr substringToIndex:index];
    }else{
        //有人看到显示0，而不是0.00的情况，不能重现，这里加一个判断
        if ([amountStr doubleValue] < 0.000001) {
            amountStr = @"0.00";
        }
    }
    return amountStr;
}
- (CGFloat) getNumberFromInput:(double) input
{
    return (CGFloat) ((cos((input + 1.0) * M_PI) / 2.0) + 0.5);
}
- (void) setHideFraction:(BOOL)hideFraction
{
    _hideFraction = hideFraction;
}
- (void) dealloc
{
    [self stopAnimation];
}

- (void) stopAnimation
{
    if (_amountUpdateTimer != nil) {
        [_amountUpdateTimer invalidate];
        _amountUpdateTimer = nil;
    }
}
@end