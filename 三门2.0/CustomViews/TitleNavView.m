//
//  TitleNavView.m
//  VCScroller
//
//  Created by lcc on 13-12-17.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "TitleNavView.h"

#define TWOWIDTH   148
#define THREEWIDTH 98
#define FOURWIDTH  73

@implementation TitleNavView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tagArr = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -
#pragma mark - custom 
- (void) setContent
{
    NSInteger width = 0;
    float fontSize = 14;
    
    switch ([self.tagArr count])
    {
        case 2:
            width = TWOWIDTH;
            break;
            
        case 3:
            width = THREEWIDTH;
            break;
            
        case 4:
            width = FOURWIDTH;
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < [self.tagArr count]; i ++)
    {
        UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tmpBtn addTarget:self action:@selector(tagTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tmpBtn];
        tmpBtn.tag = i + 10;
        tmpBtn.frame = CGRectMake((width + 1)*i, 0, width, 30);
        if (i == 0)
        {
            [tmpBtn setTitleColor:[UIColor colorWithRed:32.0f/255.0f green:118.0f/255.0f blue:197.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [tmpBtn setBackgroundColor:[UIColor whiteColor]];
            currentBtn = tmpBtn;
        }
        else
        {
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tmpBtn setBackgroundColor:[UIColor colorWithRed:32.0f/255.0f green:118.0f/255.0f blue:197.0f/255.0f alpha:1.0f]];
        }
        
        [tmpBtn setTitle:[self.tagArr objectAtIndex:i] forState:UIControlStateNormal];
        [tmpBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    }
}

- (void) selectAtIndex:(NSInteger) tagIndex
{
    if (tagIndex != currentBtn.tag)
    {
        [currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [currentBtn setBackgroundColor:[UIColor colorWithRed:32.0f/255.0f green:118.0f/255.0f blue:197.0f/255.0f alpha:1.0f]];
        
        currentBtn = (UIButton *)[self viewWithTag:tagIndex + 10];
        
        [currentBtn setTitleColor:[UIColor colorWithRed:32.0f/255.0f green:118.0f/255.0f blue:197.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [currentBtn setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void) tagTapped:(UIButton *) sender
{
    if (sender.tag != currentBtn.tag)
    {
        [currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [currentBtn setBackgroundColor:[UIColor colorWithRed:32.0f/255.0f green:118.0f/255.0f blue:197.0f/255.0f alpha:1.0f]];
        
        currentBtn = sender;
        
        [currentBtn setTitleColor:[UIColor colorWithRed:32.0f/255.0f green:118.0f/255.0f blue:197.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [currentBtn setBackgroundColor:[UIColor whiteColor]];
        
        if (self.t_delegate && [self.t_delegate respondsToSelector:@selector(titleNavViewSelectAtIndex:)])
        {
            [self.t_delegate titleNavViewSelectAtIndex:sender.tag - 10];
        }
    }
}

@end
