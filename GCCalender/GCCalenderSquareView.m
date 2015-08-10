//
//  GCCalenderSquareView.m
//  GCCalenderDemo
//
//  Created by 辰 宫 on 15/8/6.
//  Copyright © 2015年 辰 宫. All rights reserved.
//

#import "GCCalenderSquareView.h"

@implementation GCCalenderSquareView
{
    CGFloat frameWidth;
    
    UILabel *dayLabel;
    
    UILabel *topLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        frameWidth = frame.size.width;
        
        dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameWidth)];
        [dayLabel setTextAlignment:NSTextAlignmentCenter];
        [dayLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:dayLabel];
        
        topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameWidth / 2.5)];
        [topLabel setTextAlignment:NSTextAlignmentCenter];
        [topLabel setFont:[UIFont systemFontOfSize:10]];
        [topLabel setTextColor:[UIColor grayColor]];
        [self addSubview:topLabel];
        
        UITapGestureRecognizer *tipGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipDateView:)];
        tipGesture.numberOfTapsRequired = 1;
        tipGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tipGesture];
    }
    
    return self;
}

- (void)setDay:(NSInteger)day
{
    _day = day;
    
    if (dayLabel) {
        [dayLabel setText:[NSString stringWithFormat:@"%ld",(long)day]];
    }
}

- (void)setTopText:(NSString *)topText
{
    if (topLabel) {
        [topLabel setText:topText];
    }
}

- (void)setIsCurrentMonth:(BOOL)isCurrentMonth
{
    if (isCurrentMonth) {
        [dayLabel setTextColor:[UIColor darkTextColor]];
    } else {
        [dayLabel setTextColor:[UIColor lightGrayColor]];
    }
}

- (void)tipDateView:(UIGestureRecognizer *)sender{
    
    NSLog(@"选中的日期：%d年%d月%d日",_year,_month,_day);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
