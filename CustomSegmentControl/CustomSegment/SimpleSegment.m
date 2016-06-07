//
//  SimpleSegment.m
//  CustomSegmentControl
//
//  Created by 诸葛游 on 16/6/6.
//  Copyright © 2016年 fengYeHen. All rights reserved.
//

#import "SimpleSegment.h"

static CGFloat const lineHeight = 3;
static CGFloat const lineHorizontalSpace = 2;
static CGFloat const lineVerticalSpace = 5;

static CGFloat const fontSizeDefaut = 15;
static NSString *const titleItemReuseIdentifier = @"title";

#define SELETED_COLOR [UIColor blueColor]
#define DEFAUT_COLOR [UIColor grayColor];


@interface SimpleSegment ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat lineWidth;
@end


@implementation SimpleSegment

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _font = [UIFont systemFontOfSize:fontSizeDefaut];
        _seletedColor = SELETED_COLOR;
        _defautColor = DEFAUT_COLOR;
        
        [self addSubview:self.collectionView];
        [_collectionView addSubview:self.lineView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _font = [UIFont systemFontOfSize:fontSizeDefaut];
        _seletedColor = SELETED_COLOR;
        _defautColor = DEFAUT_COLOR;
        
        [self addSubview:self.collectionView];
        [_collectionView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    self.collectionView.frame = self.bounds;
    if (0 == self.lineView.frame.origin.y) {
        self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-lineHeight, _lineWidth, lineHeight);
    }
}

#pragma mark - methods
- (void)findTheMaxLength {
    if (_itemTitles.count > 0) {
        
        __block NSString *maxLengthTitle = @"";
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSString *title in _itemTitles) {
                if (title.length > maxLengthTitle.length) {
                    maxLengthTitle = title;
                }
            }
            
            NSDictionary *attributes = @{NSFontAttributeName:_font};
            self.lineWidth = [maxLengthTitle boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
            });
        });
    }
}

- (void)resetLineViewFrameBySelectedIndexPath:(NSIndexPath *)indexPath previousIndexPath:(NSIndexPath *)previousIndexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(simpleSegment:seletedIndex:previousIndex:)]) {
        [self.delegate simpleSegment:self seletedIndex:indexPath.item previousIndex:previousIndexPath.item];
    }
    TitleItemCell *previousCell = (TitleItemCell *)[_collectionView cellForItemAtIndexPath:previousIndexPath];
    TitleItemCell *selectedCell = (TitleItemCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    previousCell.titleLabel.textColor = _defautColor;
    selectedCell.titleLabel.textColor = _seletedColor;
    
    CGRect temp = selectedCell.frame;
    _lineView.frame = CGRectMake(CGRectGetMinX(temp),
                                 CGRectGetHeight(temp)-lineHeight, _lineWidth, lineHeight);
    _selectedIndex = indexPath.item;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.bounds.size.height;
    if (0 == _selectedIndex && 0 == indexPath.item) {
        CGRect newFrame = _lineView.frame;
        newFrame.size.width = _lineWidth;
        _lineView.frame = newFrame;
    }
    return CGSizeMake(_lineWidth, height);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TitleItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleItemReuseIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = _itemTitles[indexPath.item];
    cell.titleLabel.font = _font;
    NSLog(@"%ld", indexPath.item);
    if (_selectedIndex == indexPath.item) {
        cell.titleLabel.textColor = _seletedColor;
    } else {
        cell.titleLabel.textColor = _defautColor;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    [self resetLineViewFrameBySelectedIndexPath:indexPath previousIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = lineHorizontalSpace;
        layout.minimumLineSpacing = lineVerticalSpace;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TitleItemCell class] forCellWithReuseIdentifier:titleItemReuseIdentifier];
    }
    return _collectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = SELETED_COLOR;
        _lineView.layer.cornerRadius = 1;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

#pragma mark - setter
- (void)setItemTitles:(NSArray *)itemTitles {
    _itemTitles = itemTitles;
    [self findTheMaxLength];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self findTheMaxLength];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self resetLineViewFrameBySelectedIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] previousIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
}

- (void)setSeletedColor:(UIColor *)seletedColor {
    _seletedColor = seletedColor;
    [self.collectionView reloadData];
}

- (void)setDefautColor:(UIColor *)defautColor {
    _defautColor = defautColor;
    [self.collectionView reloadData];
}

@end

#pragma mark -
#pragma mark - TitleItemCell
@interface TitleItemCell ()

@end

@implementation TitleItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    self.titleLabel.frame = self.bounds;
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:fontSizeDefaut];
        _titleLabel.textColor = DEFAUT_COLOR;
    }
    return _titleLabel;
}

@end

