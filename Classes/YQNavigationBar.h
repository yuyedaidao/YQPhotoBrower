//
//  YQNavigationBar.h
//  YQPhotoBrower
//
//  Created by Leaf on 14-10-13.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQNavigationBar : UIToolbar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;

@end
