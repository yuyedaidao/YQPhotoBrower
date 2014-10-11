//
//  YQPotoBrowerController.m
//  YQPhotoBrower
//
//  Created by Leaf on 14-10-10.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

#import "YQPotoBrowerController.h"
#import "YQPhotoBrowerCell.h"


@interface YQPotoBrowerController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL _leaveStatusBarAlone;
    BOOL _isVCBasedStatusBarAppearance;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign) BOOL showStatusBar;
@end

@implementation YQPotoBrowerController

static NSString * const reuseIdentifier = @"YQPhotoBrowerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    self.view.frame = CGRectMake(self.view.frame.size.width, 0, 130, 288);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setItemSize:self.view.bounds.size];
    layout.minimumLineSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    // Register cell classes
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    [self setNavBarAppearance:YES];
    // Do any additional setup after loading the view.
    
    //读取配置文件看状态栏是不是根据视图控制器定
    NSNumber *isVCBasedStatusBarAppearanceNum = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (isVCBasedStatusBarAppearanceNum) {
        _isVCBasedStatusBarAppearance = isVCBasedStatusBarAppearanceNum.boolValue;
    } else {
        _isVCBasedStatusBarAppearance = YES; // default
    }
    _leaveStatusBarAlone = [self presentingViewControllerPrefersStatusBarHidden];

    if (CGRectEqualToRect([[UIApplication sharedApplication] statusBarFrame], CGRectZero)) {
        // If the frame is zero then definitely leave it alone
        _leaveStatusBarAlone = YES;
    }
    
    if(self.navigationController){
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.textColor = self.navigationController.navigationBar.tintColor;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.navigationItem setTitleView:self.titleLabel];
        //        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"2.jpg"] forBarMetrics:UIBarMetricsDefault];
        //        [self.navigationController.navigationBar setBackgroundColor:<#(UIColor *)#>];
        //        [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"1.jpg"]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(options:)];
    }
    
}
-(void)options:(id)sender{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YQPhotoBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.viewController = self;
//    cell.scrollView.frame = cell.scrollView.bounds;
//    cell.imgView.frame = cell.scrollView.bounds;
    // Configure the cell
    NSLog(@"======");
//    cell.scrollView.zoomScale = 1.0f;
    cell.imgView.image = self.photoArray[indexPath.item];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return self.view.bounds.size;
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"||||||");
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma statusbar
-(void)showOrHideStatusBar:(BOOL)animated{
    
    [self showStatusBar:!self.prefersStatusBarHidden anmiated:animated];
}
-(void)showStatusBar:(BOOL)show anmiated:(BOOL)animated{
    self.showStatusBar = show;
    NSLog(@"hello");
    [self.navigationController setNavigationBarHidden:show animated:YES];
    if(_isVCBasedStatusBarAppearance){
        [UIView animateWithDuration:0.3 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];

    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:show withAnimation:UIStatusBarAnimationSlide];
    }
    
    
}

- (void)setNavBarAppearance:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    
    navBar.barTintColor = nil;
    navBar.shadowImage = nil;
    navBar.translucent = YES;
    
    navBar.barStyle = UIBarStyleBlackTranslucent;
    
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsLandscapePhone];
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
//}

- (BOOL)prefersStatusBarHidden
{
    if (!_leaveStatusBarAlone) {
        return self.showStatusBar;
    } else {
        return [self presentingViewControllerPrefersStatusBarHidden];
    }
    //返回NO表示要显示，返回YES将hiden
}
- (BOOL)presentingViewControllerPrefersStatusBarHidden {
    UIViewController *presenting = self.presentingViewController;
    if (presenting) {
        if ([presenting isKindOfClass:[UINavigationController class]]) {
            presenting = [(UINavigationController *)presenting topViewController];
        }
    } else {
        // We're in a navigation controller so get previous one!
        if (self.navigationController && self.navigationController.viewControllers.count > 1) {
            presenting = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        }
    }
    if (presenting) {
        return [presenting prefersStatusBarHidden];
    } else {
        return NO;
    }
}

@end
