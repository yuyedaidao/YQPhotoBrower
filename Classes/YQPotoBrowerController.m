//
//  YQPotoBrowerController.m
//  YQPhotoBrower
//
//  Created by Leaf on 14-10-10.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

#import "YQPotoBrowerController.h"
#import "YQPhotoBrowerCell.h"
#import "YQNavigationBar.h"

@interface YQPotoBrowerController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    BOOL _leaveStatusBarAlone;
    BOOL _isVCBasedStatusBarAppearance;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign) BOOL showStatusBar;
@property (nonatomic,assign) YQNavigationBar *navBar;
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation YQPotoBrowerController

static NSString * const reuseIdentifier = @"YQPhotoBrowerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    self.currentPage = 1;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setItemSize:self.view.bounds.size];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
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

//    [self setNavBarAppearance:YES];
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
    
    //自定义导航栏
    self.navBar = [[[NSBundle mainBundle] loadNibNamed:@"YQNavigationBar" owner:nil options:nil] lastObject];
    self.navBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    [self.view addSubview:self.navBar];
    
    self.navBar.backItem.target = self;
    self.navBar.backItem.action = @selector(back);
    
    //标题
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [spaceView addSubview:self.titleLabel];
    self.navBar.titleItem.customView = spaceView;
    [self updateTitle];
    
    //删除Item
    self.navBar.cancelItem.target = self;
    self.navBar.cancelItem.action = @selector(deletePhoto);
}
-(void)updateTitle{
    [self.titleLabel setText:[NSString stringWithFormat:@"%d/%d",self.currentPage,self.photoArray.count]];
}
-(void)deletePhoto{
    
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
   
    cell.scrollView.frame = cell.bounds;
//    cell.scrollView.contentSize = CGSizeMake(cell.bounds.size.width*2, cell.bounds.size.height*2);
    cell.imgView.frame = cell.scrollView.bounds;
    NSLog(@"cell frame = %@",NSStringFromCGRect(cell.scrollView.frame));
    [cell reset];
    
    cell.imgView.image = self.photoArray[indexPath.item];
    return cell;
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"||||||");
//}

#pragma statusbar
-(void)showOrHideStatusBar:(BOOL)animated{
    
    [self showStatusBar:!self.prefersStatusBarHidden anmiated:animated];
}

-(void)showStatusBar:(BOOL)show anmiated:(BOOL)animated{
    self.showStatusBar = show;
   
    [self.navigationController setNavigationBarHidden:show animated:YES];
    if(_isVCBasedStatusBarAppearance){
        [UIView animateWithDuration:0.3 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];

    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:show withAnimation:UIStatusBarAnimationSlide];
    }
    
    CGRect rect = self.navBar.frame;
    if(!show){
        if(rect.origin.y!=0){
            [UIView animateWithDuration:0.3 animations:^{
                
                self.navBar.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            }];
        }
    }else{
        if(rect.origin.y!=-rect.size.height){
            [UIView animateWithDuration:0.3 animations:^{
                self.navBar.frame = CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height);
            }];
        }
    }
    
    
}
#pragma scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    CGPoint offset = scrollView.contentOffset;
    NSInteger page = (offset.x+scrollView.bounds.size.width/2)/scrollView.bounds.size.width+1;
    if(page!=self.currentPage){
        self.currentPage = page;
        [self updateTitle];
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
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

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
