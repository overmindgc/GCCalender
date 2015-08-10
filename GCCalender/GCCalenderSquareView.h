//
//  GCCalenderSquareView.h
//  GCCalenderDemo
//
//  Created by 辰 宫 on 15/8/6.
//  Copyright © 2015年 辰 宫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCCalenderSquareView : UIView

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, copy) NSString *topText;

//当前各自是否是当前月
@property (nonatomic, assign) BOOL isCurrentMonth;

@end
