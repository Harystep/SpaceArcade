//
//  YDPushRechargeAlertView.m
//  game_wwj
//
//  Created by oneStep on 2023/11/27.
//

#import "YDPushRechargeAlertView.h"
#import "YDPushRechargeItemCardCell.h"
#import "YDPushRechargePackCardCell.h"
#import "YDPushRechargeModel.h"
#import "YDPushWalletView.h"
#import "ZCUserGameService.h"

@interface YDPushRechargeAlertView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) YDPushWalletView *walletView;

@end

@implementation YDPushRechargeAlertView


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
    [maskBtn addTarget:self action:@selector(hideRechargeView) forControlEvents:UIControlEventTouchUpInside];
    
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
    titleL.text = @"充值中心";
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
    
    [self getRechargeListInfo];
}

- (void)getRechargeListInfo {
    [ZCUserGameService getRechargeListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSMutableArray *dataArr = [NSMutableArray array];
        NSDictionary *monthDic = responseObj[@"data"][@"month"];
        NSDictionary *weekDic = responseObj[@"data"][@"week"];
        NSArray *normalArr = responseObj[@"data"][@"normal"];
        [dataArr addObject:[YDPushRechargeModel mj_objectWithKeyValues:weekDic]];
        [dataArr addObject:[YDPushRechargeModel mj_objectWithKeyValues:monthDic]];
        [dataArr addObjectsFromArray:[YDPushRechargeModel mj_objectArrayWithKeyValuesArray:normalArr]];
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
    YDPushRechargeModel *model = self.dataArr[indexPath.row];
    if(indexPath.row == 0 || indexPath.row == 1) {
        YDPushRechargePackCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDPushRechargePackCardCell" forIndexPath:indexPath];
        cell.type = indexPath.row;
        if([model.title isEqualToString:@"月卡"]) {
            cell.bgIcon.image = [UIImage imageNamed:@"push_charge_month_bg_icon"];
        } else {
            cell.bgIcon.image = [UIImage imageNamed:@"push_charge_week_bg_icon"];
        }
        cell.model = model;
        return cell;
    } else {
        YDPushRechargeItemCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDPushRechargeItemCardCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat viewWidth = self.collectionView.frame.size.width;
    if(indexPath.row == 0 || indexPath.row == 1) {
        return CGSizeMake(viewWidth-20, 140);
    } else {
        
        return CGSizeMake((viewWidth-30)/2.0, 180);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YDPushRechargeModel *model = self.dataArr[indexPath.row];
    if(self.selectRechargeItemBlock) {
        self.selectRechargeItemBlock(model);
    }
}

- (void)showRechargeView {
    self.frame = UIScreen.mainScreen.bounds;
    [UIApplication.sharedApplication.windows.firstObject addSubview:self];
    self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.maskBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideRechargeView {
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
        [_collectionView registerClass:[YDPushRechargePackCardCell class] forCellWithReuseIdentifier:@"YDPushRechargePackCardCell"];
        [_collectionView registerClass:[YDPushRechargeItemCardCell class] forCellWithReuseIdentifier:@"YDPushRechargeItemCardCell"];
    }
    return _collectionView;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.walletView.dataDic = dataDic;
}

@end
