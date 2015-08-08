//
//  GCCalenderView.m
//  GCCalenderDemo
//
//  Created by 辰 宫 on 15/8/6.
//  Copyright © 2015年 辰 宫. All rights reserved.
//

#import "GCCalenderView.h"

//一行七天
static const NSInteger dayNumberInLine = 7;
//一共6行
static const NSInteger numberOfLines = 6;

@implementation GCCalenderView
{
    CGFloat frameWidth;
    CGFloat frameHeight;
    
    //每个日期格子的宽
    CGFloat squareWidth;
    
    //日历对象
    NSCalendar *gregorian;
    NSDate *nowDate;//保存当前日期（0点计算）
    
    UIScrollView *dateScrollView;//日期滚动视图
    UILabel *monthNameLabel;//月份标签
    
    //包括前后个月的视图
    UIView *lastMonthView;
    UIView *thisMonthView;
    UIView *nextMonthView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        frameWidth = frame.size.width;
        frameHeight = frame.size.height;
        _selectType = GCClanderSelectTypeRange;
        _selectColor = [UIColor colorWithRed:52/255.f green:154/255.f blue:239/255.f alpha:1.0];
        squareWidth = frameWidth / dayNumberInLine;
        nowDate = [NSDate date];
        
        CGFloat paddingBottom = frameHeight - squareWidth * numberOfLines;
        
        CGFloat dayViewHeight = squareWidth * numberOfLines;
        //创建日期滚动scrollview
        dateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, paddingBottom, frameWidth, dayViewHeight)];
        dateScrollView.delegate = self;
        dateScrollView.bounces = YES;
        [dateScrollView setBackgroundColor:[UIColor whiteColor]];
        dateScrollView.showsHorizontalScrollIndicator = NO;
        dateScrollView.showsVerticalScrollIndicator = NO;
        dateScrollView.alwaysBounceVertical = YES;
        dateScrollView.pagingEnabled = YES;
        [self addSubview:dateScrollView];
        dateScrollView.contentSize = CGSizeMake(frameWidth, dayViewHeight * 3);
        
        //创建当前和前后月view
        for (NSInteger i=0; i<3; i++) {
            UIView *monthView = [[UIView alloc] initWithFrame:CGRectMake(0, i * dayViewHeight, frameWidth, dayViewHeight)];
            if (i == 0) {
                lastMonthView = monthView;
                [monthView setBackgroundColor:[UIColor whiteColor]];
            } else if (i == 1) {
                thisMonthView = monthView;
                [monthView setBackgroundColor:[UIColor whiteColor]];
            } else {
                nextMonthView = monthView;
                [monthView setBackgroundColor:[UIColor whiteColor]];
            }
            [dateScrollView addSubview:monthView];
        }
        
        [dateScrollView scrollRectToVisible:CGRectMake(0, dayViewHeight, frameWidth, dayViewHeight) animated:NO];
        
        //分隔线
        CGFloat sepraterHeight = 1.0f;
        UIView *sepraterView = [[UIView alloc] initWithFrame:CGRectMake(0, paddingBottom - sepraterHeight, frameWidth, sepraterHeight)];
        [sepraterView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self addSubview:sepraterView];
        
        paddingBottom = paddingBottom - sepraterHeight;
        
        UIColor *topBarBgColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        //星期文字行
        NSArray *weekNames = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
        CGFloat weekHeight = squareWidth * 0.6;
        UIView *weekBgView = [[UIView alloc] initWithFrame:CGRectMake(0, paddingBottom - weekHeight, frameWidth, weekHeight)];
        [weekBgView setBackgroundColor:topBarBgColor];
        [self addSubview:weekBgView];
        for (NSInteger j=0; j < weekNames.count; j++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(j * squareWidth, 0, squareWidth, weekHeight)];
            [weekLabel setText:[weekNames objectAtIndex:j]];
            [weekLabel setTextAlignment:NSTextAlignmentCenter];
            [weekLabel setTextColor:[UIColor grayColor]];
            [weekLabel setFont:[UIFont systemFontOfSize:12]];
            [weekBgView addSubview:weekLabel];
        }
        
        paddingBottom = paddingBottom - weekHeight;
        
        //翻页和月份标签
        CGFloat monthBarHeight = squareWidth * 0.9;
        UIView *monthBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, paddingBottom - monthBarHeight, frameWidth, monthBarHeight)];
        [monthBarBgView setBackgroundColor:topBarBgColor];
        [self addSubview:monthBarBgView];
        
        CGFloat monthLabelWidth = 100;
        monthNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth/2 - monthLabelWidth/2, 0, monthLabelWidth, monthBarHeight)];
        [monthNameLabel setText:@"八月"];
        [monthNameLabel setTextAlignment:NSTextAlignmentCenter];
        [monthBarBgView addSubview:monthNameLabel];
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, squareWidth, monthBarHeight)];
        [leftButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [monthBarBgView addSubview:leftButton];
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(frameWidth - squareWidth, 0, squareWidth, monthBarHeight)];
        [rightButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [monthBarBgView addSubview:rightButton];
        
        paddingBottom = paddingBottom - monthBarHeight;
        
        //选中状态和按钮视图
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    
}

#pragma mark UISCrollViewDelegate
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
    
}


@end
