//
//  YDPushExchangeAlertView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDPushExchangeAlertView.h"
#import <Masonry/Masonry.h>
#import "YDPushExchangeItemCell.h"
#import "YDPushExchangeModel.h"
#import "YDPushWalletView.h"
#import "ZCUserGameService.h"

@interface YDPushExchangeAlertView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) YDPushWalletView *walletView;

@end

@implementation YDPushExchangeAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIButton *maskBtn = [[UIButton alloc] init];
    [self addSubview:maskBtn];
    maskBtn.backgroundColor = UIColor.blackColor;
    maskBtn.alpha = 0.8;
    [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.maskBtn = maskBtn;
    [maskBtn addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(10);
        make.top.mas_equalTo(self.mas_top).offset(100);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageNamed:@"push_alert_bg_icon"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    self.contentView = bgView;
    
    [bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(bgView);
        make.top.mas_equalTo(bgView.mas_top).offset(100);
    }];
    [self.collectionView layoutIfNeeded];
    
    UILabel *titleL = [[UILabel alloc] init];
    [bgView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).offset(10);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(bgView.mas_centerX);
    }];
    titleL.text = @"能量转换";
    titleL.textColor = UIColor.whiteColor;
    titleL.font = [UIFont boldSystemFontOfSize:17];
    
    UIView *lineView = [[UIView alloc] init];
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(bgView).inset(12);
        make.top.mas_equalTo(titleL.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    lineView.alpha = 0.46;
    lineView.backgroundColor = UIColor.grayColor;
    
    self.walletView = [[YDPushWalletView alloc] init];
    [bgView addSubview:self.walletView];
    [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(bgView.mas_leading).offset(10);
        make.top.mas_equalTo(lineView.mas_top).offset(15);
    }];
    
    [self getExchangeListInfo];
}

- (void)getExchangeListInfo {
    [ZCUserGameService getPointsExchangeListURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSMutableArray *dataArr = [NSMutableArray array];
        [dataArr addObjectsFromArray:[YDPushExchangeModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
        self.dataArr = dataArr;
    }];
}


- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    YDPushExchangeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDPushExchangeItemCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat viewWidth = self.collectionView.frame.size.width;
    return CGSizeMake((viewWidth-30)/2.0, 145);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YDPushExchangeModel *model = self.dataArr[indexPath.row];
    if(self.selectExchangeItemBlock) {
        self.selectExchangeItemBlock(model);
    }
}

- (void)showAlertView {
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.windows.firstObject addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAlertView {
    self.maskBtn.hidden = YES;
    self.contentView.hidden = YES;
    [self removeFromSuperview];
}


#pragma mark - lazy UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [_collectionView registerClass:[YDPushExchangeItemCell class] forCellWithReuseIdentifier:@"YDPushExchangeItemCell"];
    }
    return _collectionView;
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.walletView.dataDic = dataDic;
}

@end
