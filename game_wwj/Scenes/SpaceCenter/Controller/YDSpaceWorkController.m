//
//  YDSpaceWorkController.m
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import "YDSpaceWorkController.h"
#import "YDSpaceWorkLevelView.h"
#import "YDSpaceWorkItemCell.h"
#import "ZCUserGameService.h"

@interface YDSpaceWorkController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) YDSpaceWorkLevelView *levelView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *workArr;

@property (nonatomic,copy) NSString *taskKey;

@property (nonatomic,strong) UIButton *receiveBtn;

@property (nonatomic,strong) UILabel *rewardL;

@end

@implementation YDSpaceWorkController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];    
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(120, 43, 218, 1);
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kImage(@"space_work_bg_icon")];
    [self.view addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(208);
    }];
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
     
    self.levelView = [[YDSpaceWorkLevelView alloc] init];
    [self.view addSubview:self.levelView];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(-4);
        make.top.mas_equalTo(bgIv.mas_bottom);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.levelView.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.receiveBtn];
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(30);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(50);
    }];
    self.receiveBtn.hidden = YES;
    
    self.rewardL = [[UILabel alloc] init];
    [bgIv addSubview:self.rewardL];
    [self.rewardL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(bgIv);
        make.height.mas_equalTo(40);
    }];
    self.rewardL.backgroundColor = rgba(0, 0, 0, 0.5);
    self.rewardL.textColor = UIColor.whiteColor;
    self.rewardL.font = kFont(15);
    
    [self getSpaceWorkListInfo];
}

- (void)getSpaceWorkListInfo {
    [ZCUserGameService getSpaceWorkListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        self.workArr = responseObj[@"data"][@"data"];
        self.taskKey = responseObj[@"data"][@"key"];
        NSDictionary *dataDic = responseObj[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger completeProgress = [dataDic[@"completeProgress"] integerValue];
            NSInteger totalProgress = [dataDic[@"totalProgress"] integerValue];
            NSString *valueStr = [NSString stringWithFormat:@"%@太空币", dataDic[@"reward"]];
            NSString *content = [NSString stringWithFormat:@"    完成任务可额外获得%@", valueStr];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
            [attr addAttribute:NSForegroundColorAttributeName value:UIColor.yellowColor range:NSMakeRange(content.length-valueStr.length, valueStr.length)];
            self.rewardL.attributedText = attr;
            if (completeProgress == totalProgress) {
                self.receiveBtn.hidden = NO;
                if([dataDic[@"receiveStatus"] integerValue] == 1) {
                    self.receiveBtn.selected = YES;
                } else {
                    self.receiveBtn.selected = NO;
                }
            } else {
                self.receiveBtn.hidden = YES;
            }
            self.levelView.dataDic  = dataDic;
            [self.tableView reloadData];
        });
    }];
}

- (void)receiveSpaceWorkOperate:(NSDictionary *) childDic{
    [ZCUserGameService receiveSpaceWorkListInfoURL:childDic completeHandler:^(id  _Nonnull responseObj) {
        [self getSpaceWorkListInfo];
    }];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if([eventName isEqualToString:@"work"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        dic[@"taskKey"] = self.taskKey;
        [self receiveSpaceWorkOperate:dic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDSpaceWorkItemCell *cell = [YDSpaceWorkItemCell spaceWorkItemCellWithTableView:tableView indexPath:indexPath];
    cell.dataDic = self.workArr[indexPath.row];
    return cell;
}

- (void)receiveBtnClick {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"taskKey"] = self.taskKey;
    [self receiveSpaceWorkOperate:dic];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView registerClass:[YDSpaceWorkItemCell class] forCellReuseIdentifier:@"YDSpaceWorkItemCell"];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)receiveBtn {
    if (_receiveBtn == nil) {
        _receiveBtn = [[UIButton alloc] init];
        [_receiveBtn setBackgroundImage:[UIImage imageNamed:@"space_work_receive_bg"] forState:UIControlStateNormal];
        [_receiveBtn setBackgroundImage:[UIImage imageNamed:@"space_work_item_incomplete_bg"] forState:UIControlStateSelected];
        [_receiveBtn addTarget:self action:@selector(receiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_receiveBtn setTitle:@"领取奖励" forState:UIControlStateNormal];
        [_receiveBtn setTitle:@"已领取" forState:UIControlStateSelected];
        [_receiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    }
    return _receiveBtn;
}

@end
