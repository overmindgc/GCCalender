//
//  GCCalenderView.m
//  GCCalenderDemo
//
//  Created by 辰 宫 on 15/8/6.
//  Copyright © 2015年 辰 宫. All rights reserved.
//

#import "GCCalenderView.h"
#import "GCCalenderSquareView.h"

//一行七天
static const NSInteger weekDayNumber = 7;
//一共6行
static const NSInteger numberOfLines = 6;

@implementation GCCalenderView
{
    CGFloat frameWidth;
    CGFloat frameHeight;
    
    //每个日期格子的宽
    CGFloat squareWidth;
    //日期视图高度
    CGFloat dayViewHeight;
    
    //日历对象
    NSCalendar *gregorian;
    NSDate *nowDate;//保存当前日期（0点计算）
    
    UIScrollView *dateScrollView;//日期滚动视图
    UILabel *monthNameLabel;//月份标签
    
    NSInteger monthOffset;//月份较当前月偏移月数
    
    NSMutableArray *daySquareViewArray;
    
    NSInteger currentYear;
    NSInteger currentMonth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        monthOffset = 0;
        frameWidth = frame.size.width;
        frameHeight = frame.size.height;
        _selectType = GCClanderSelectTypeRange;
        _selectColor = [UIColor colorWithRed:52/255.f green:154/255.f blue:239/255.f alpha:1.0];
        squareWidth = frameWidth / weekDayNumber;
        nowDate = [NSDate date];
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        CGFloat paddingBottom = frameHeight - squareWidth * numberOfLines;
        
        dayViewHeight = squareWidth * numberOfLines;
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
        
        daySquareViewArray = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<weekDayNumber*numberOfLines*3; i++) {
            NSInteger currentLine = ceilf(i / weekDayNumber);
            NSInteger lineIndex = i % weekDayNumber;
            CGFloat sqX = lineIndex * squareWidth;
            CGFloat sqY = currentLine * squareWidth;
            GCCalenderSquareView *sqView = [[GCCalenderSquareView alloc] initWithFrame:CGRectMake(sqX, sqY, squareWidth, squareWidth)];
//            sqView.day = [NSString stringWithFormat:@"%ld",(long)i];
            [dateScrollView addSubview:sqView];
            [daySquareViewArray addObject:sqView];
        }
        
        
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
        [leftButton addTarget:self action:@selector(showLastMonthAction:) forControlEvents:UIControlEventTouchUpInside];
        [monthBarBgView addSubview:leftButton];
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(frameWidth - squareWidth, 0, squareWidth, monthBarHeight)];
        [rightButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(showNextMonthAction:) forControlEvents:UIControlEventTouchUpInside];
        [monthBarBgView addSubview:rightButton];
        
        paddingBottom = paddingBottom - monthBarHeight;
        
        
        //初始日期视图
        [self initMonthDayView];
    
        [self scrollToPageIndex:1 withAnimated:NO];
        
        [self setMonthTitleText];
        
        //选中状态和按钮视图
    }
    
    return self;
}

/**
 * 初始化月份日期视图
 */
- (void)initMonthDayView
{
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:nowDate];
    components.day = 1;
    components.month = components.month - 1 + monthOffset;
    [self initMonthDayWithFirstDayComponents:components forPageIndex:0];
    components.month = components.month + 1;
    [self initMonthDayWithFirstDayComponents:components forPageIndex:1];
    components.month = components.month + 1;
    [self initMonthDayWithFirstDayComponents:components forPageIndex:2];
}

- (void)initMonthDayWithFirstDayComponents:(NSDateComponents *)firstDayComponents forPageIndex:(NSInteger)pageIndex
{
    NSDate *firstDayDate = [gregorian dateFromComponents:firstDayComponents];
    NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit
                                   inUnit:NSMonthCalendarUnit
                                  forDate:firstDayDate];
    //获得当月的长度
    NSInteger monthLength = days.length;
    
    //获得当月1日的星期数
    NSDateComponents *weekComps = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:firstDayDate];
    NSInteger weekday = [weekComps weekday];
    //in the Gregorian calendar, n is 7 and Sunday is represented by 1.
    weekday = weekday - 2;
    if(weekday < 0) {
        weekday = 6;
    }
    
    //设置当月的日期值
    for (NSInteger i=0; i<monthLength; i++) {
        NSInteger currIndedx = pageIndex * weekDayNumber * numberOfLines + i + weekday;
        GCCalenderSquareView *currDayView = [daySquareViewArray objectAtIndex:currIndedx];
        currDayView.day = i + 1;
        currDayView.year = weekComps.year;
        currDayView.month = weekComps.month;
        currDayView.isCurrentMonth = YES;
        if (i == 0) {
            currDayView.topText = [NSString stringWithFormat:@"%ld月",(long)weekComps.month];
        } else {
            currDayView.topText = @"";
        }
        
        //如果是本月，记录一下当前的年月
        if (pageIndex == 1) {
            currentYear = weekComps.year;
            currentMonth = weekComps.month;
        }
    }
    
    //设置前边空白处日期
    if (weekday > 0) {
        weekComps.day = weekComps.day - 1;
        NSDate *forwardFirstDate = [gregorian dateFromComponents:weekComps];
        NSDateComponents *forwardFirstComps = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:forwardFirstDate];
        NSInteger forwardFirstDay = forwardFirstComps.day;
        
        for (NSInteger beforeIndex=weekday; beforeIndex>0; beforeIndex--) {
            NSInteger currIndedx_fw = pageIndex * weekDayNumber * numberOfLines + beforeIndex - 1;
            GCCalenderSquareView *currDayView_fw = [daySquareViewArray objectAtIndex:currIndedx_fw];
            currDayView_fw.day = forwardFirstDay;
            currDayView_fw.year = forwardFirstComps.year;
            currDayView_fw.month = forwardFirstComps.month;
            currDayView_fw.isCurrentMonth = NO;
            currDayView_fw.topText = @"";
            forwardFirstDay--;
        }
        //还原
        weekComps.day = weekComps.day + 1;
    }
    
    //设置后边空白处日期
    //是否有空行
    NSInteger totalLines = (monthLength + weekday + 1) / 7;
    BOOL hasBlankLine = totalLines < 5;
    NSInteger lastDayWeek = (monthLength + weekday + 1) % 7 - 1;
    if (lastDayWeek < 6 || hasBlankLine) {
        weekComps.day = weekComps.day + monthLength;
        NSDate *backwardFirstDate = [gregorian dateFromComponents:weekComps];
        NSDateComponents *backwardFirstComps = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:backwardFirstDate];
        NSInteger backwardFirstDay = backwardFirstComps.day;
        //补全空余
        NSInteger currIndedx_back = 0;
        for (NSInteger backIndex=0; backIndex<weekDayNumber - lastDayWeek; backIndex++) {
            currIndedx_back = pageIndex * weekDayNumber * numberOfLines + monthLength + weekday + backIndex;
            GCCalenderSquareView *currDayView_back = [daySquareViewArray objectAtIndex:currIndedx_back];
            currDayView_back.day = backwardFirstDay;
            currDayView_back.year = backwardFirstComps.year;
            currDayView_back.month = backwardFirstComps.month;
            currDayView_back.isCurrentMonth = NO;
            currDayView_back.topText = @"";
            backwardFirstDay++;
        }
        //补全空行
        if (hasBlankLine) {
            for (NSInteger w=0; w<weekDayNumber; w++) {
                currIndedx_back++;
                GCCalenderSquareView *currDayView_back = [daySquareViewArray objectAtIndex:currIndedx_back];
                currDayView_back.day = backwardFirstDay;
                currDayView_back.isCurrentMonth = NO;
                backwardFirstDay++;
            }
        }
    }
}

#pragma marks acitons
- (void)showLastMonthAction:(id)sender
{
    [self scrollToPageIndex:0 withAnimated:YES];
}

- (void)showNextMonthAction:(id)sender
{
    [self scrollToPageIndex:2 withAnimated:YES];
}


/**
 * 滚动视图到位置页 0,1,2
 */
- (void)scrollToPageIndex:(NSInteger)pageIndex withAnimated:(BOOL)animated
{
    [dateScrollView scrollRectToVisible:CGRectMake(0, dayViewHeight * pageIndex, frameWidth, dayViewHeight) animated:animated];
}

- (void)initNextMonth
{
    monthOffset++;
    [self initMonthDayView];
    [self scrollToPageIndex:1 withAnimated:NO];
    [self setMonthTitleText];
}

- (void)initLastMonth
{
    monthOffset--;
    [self initMonthDayView];
    [self scrollToPageIndex:1 withAnimated:NO];
    [self setMonthTitleText];
}

- (void)setMonthTitleText
{
    [monthNameLabel setText:[NSString stringWithFormat:@"%ld年%ld月",(long)currentYear,(long)currentMonth]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

#pragma mark UISCrollViewDelegate
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
    //上滑
    if (scrollView.contentOffset.y == 0) {
        [self initLastMonth];
        return;
    }
    
    //下滑
    if (scrollView.contentOffset.y > dayViewHeight + 1) {
        [self initNextMonth];
        return;
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    //上滑
    if (scrollView.contentOffset.y == 0) {
        [self initLastMonth];
        return;
    }
    
    //下滑
    if (scrollView.contentOffset.y > dayViewHeight + 1) {
        [self initNextMonth];
        return;
    }
}


@end
