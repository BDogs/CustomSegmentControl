//
//  SimpleSegment.h
//  CustomSegmentControl
//
//  Created by 诸葛游 on 16/6/6.
//  Copyright © 2016年 fengYeHen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleSegment;
@protocol SimpleSegmentDelegate <NSObject>

- (void)simpleSegment:(SimpleSegment *)simpleSegment
         seletedIndex:(NSInteger)selectedIndex
        previousIndex:(NSInteger)previousIndex;

@end

@interface SimpleSegment : UIView
@property (nonatomic, weak) id<SimpleSegmentDelegate> delegate;
@property (nonatomic, copy) NSArray *itemTitles;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *seletedColor;
@property (nonatomic, strong) UIColor *defautColor;


@end

@interface TitleItemCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;

@end