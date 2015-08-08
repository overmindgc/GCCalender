//
//  GCCalenderView.h
//  GCCalenderDemo
//
//  Created by 辰 宫 on 15/8/6.
//  Copyright © 2015年 辰 宫. All rights reserved.
//

#import <UIKit/UIKit.h>

/**日历选择模式（单选或多选）*/
typedef NS_ENUM(NSInteger, GCClanderSelectType) {
    GCClanderSelectTypeSingle,
    GCClanderSelectTypeRange,
};

@interface GCCalenderView : UIView <UIScrollViewDelegate>

/**选择日期的类型，单选或范围，默认范围*/
@property (nonatomic, assign) GCClanderSelectType selectType;

/**选中的颜色*/
@property (nonatomic, strong) UIColor *selectColor;


@end
