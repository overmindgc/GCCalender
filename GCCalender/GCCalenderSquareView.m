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
    }
    
    return self;
}

- (void)setDay:(NSString *)day
{
    if (dayLabel) {
        [dayLabel setText:day];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
