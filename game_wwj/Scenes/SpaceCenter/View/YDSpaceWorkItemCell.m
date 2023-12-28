//
//  YDSpaceWorkItemCell.m
//  game_wwj
//
//  Created by oneStep on 2023/12/1.
//

#import "YDSpaceWorkItemCell.h"

@interface YDSpaceWorkItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *coinL;

@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation YDSpaceWorkItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)spaceWorkItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    YDSpaceWorkItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDSpaceWorkItemCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:kImage(@"space_work_item_bg")];
    [self.contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.height.mas_equalTo(64);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(10);
        make.top.mas_equalTo(self.contentView);
    }];
    bgIv.userInteractionEnabled = YES;
    
    self.iconIv = [[UIImageView alloc] initWithImage:kImage(@"space_work_item_icon")];
    [bgIv addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgIv);
        make.leading.mas_equalTo(bgIv.mas_leading).offset(10);
        make.height.width.mas_equalTo(42);
    }];
    
    self.titleL = [[UILabel alloc] init];
    [bgIv addSubview:self.titleL];
    
    self.coinL = [[UILabel alloc] init];
    [bgIv addSubview:self.coinL];
    
    
    self.titleL.textColor = rgba(107, 83, 197, 1);
    self.titleL.text = @"每日任务";
    self.titleL.font = kFont(14);
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgIv);
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(19);
        make.width.mas_equalTo(150);
    }];
    self.titleL.numberOfLines = 0;
    
    self.statusBtn = [[UIButton alloc] init];
    [bgIv addSubview:self.statusBtn];
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgIv);
        make.trailing.mas_equalTo(bgIv.mas_trailing).inset(9);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(35);
    }];
    [self.statusBtn addTarget:self action:@selector(workBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.statusBtn.titleLabel.font = kBoldFont(15);
    [self.statusBtn setBackgroundImage:kImage(@"space_work_receive_bg") forState:UIControlStateSelected];
    [self.statusBtn setBackgroundImage:kImage(@"space_work_item_incomplete_bg") forState:UIControlStateNormal];
    
    CGFloat ratio = (UIScreen.mainScreen.bounds.size.width / 375.0);
    self.coinL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.coinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgIv);
        make.trailing.mas_equalTo(self.statusBtn.mas_leading).inset(18*ratio);
    }];
    [self configureCoinContentText:@"+25"];
}
//space_work_receive_bg  space_work_item_incomplete_bg

- (void)configureCoinContentText:(NSString *)content {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content attributes: @{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:237/255.0 blue:0/255.0 alpha:1.0],NSStrokeWidthAttributeName:@-5,NSStrokeColorAttributeName: [UIColor colorWithRed:188/255.0 green:109/255.0 blue:0/255.0 alpha:1.0]}];
    self.coinL.attributedText = string;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:[self safeStringWithConetent:dataDic[@"icon"]]] placeholderImage:kImage(@"space_work_item_icon")];
    self.titleL.text = [self safeStringWithConetent:dataDic[@"title"]];
    [self configureCoinContentText:[NSString stringWithFormat:@"+%@币", dataDic[@"reward"]]];
    if([dataDic[@"reached"] integerValue] == 1) {
        self.statusBtn.selected = NO;
        [self.statusBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [self.statusBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    } else if ([dataDic[@"reached"] integerValue] == 0) {
        self.statusBtn.selected = YES;
        [self.statusBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.statusBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, 0)];
    } else {
        self.statusBtn.selected = NO;
        [self.statusBtn setTitle:@"未达标" forState:UIControlStateNormal];
        [self.statusBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    }
}

- (void)workBtnClick {
    NSString *status = [NSString stringWithFormat:@"%@", self.dataDic[@"reached"]];
    if(status.length > 0 && status.integerValue == 0) {
        [self routerWithEventName:@"work" userInfo:@{@"childId":self.dataDic[@"childId"]}];
    }
}

- (NSString *)safeStringWithConetent:(NSString *)content {
    NSString *safe = @"";
    if ([content isKindOfClass:[NSNull class]]) {
        safe = @"";
    } else if (content == nil) {
        safe = @"";
    } else {
        safe = [NSString stringWithFormat:@"%@", content];
    }
    return safe;
}

@end
