//
//  EmojiLayout.h
//  StarFactory
//
//  Created by 李晓宁 on 2017/2/4.
//  Copyright © 2017年 Joygo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiLayout : UICollectionViewFlowLayout

// column
@property (nonatomic, assign) NSInteger maxColumn;
// row
@property (nonatomic, assign) NSInteger maxRow;
// margin
@property (nonatomic, assign) CGFloat margin;


@end
