//
//  YQPhotoBrowerCell.h
//  YQPhotoBrower
//
//  Created by Leaf on 14-10-10.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YQPotoBrowerController;
@interface YQPhotoBrowerCell : UICollectionViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak,nonatomic) YQPotoBrowerController *viewController;
-(void)reset;
@end
