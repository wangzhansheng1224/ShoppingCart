//
//  ViewController.m
//  cellEditing
//
//  Created by 王战胜 on 2016/11/14.
//  Copyright © 2016年 王战胜. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//总数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;
//待删除数组
@property (nonatomic, strong) NSMutableArray *deleteArray;
//全选/取消全选按钮
@property (nonatomic, strong) UIButton *selectAllBtn;
//结算/删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;
//编辑/完成按钮
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initNavigation];
    [self initBarView];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initData{
    NSArray * dataArr = @[@"0000",@"1111",@"2222",@"3333",@"4444",@"5555",@"6666",@"7777",@"8888",@"9999",@"0000",@"1111",@"2222",@"3333",@"4444",@"5555",@"6666",@"7777",@"8888",@"9999"];
    for (int i=0; i<dataArr.count; i++) {
        People *people=[[People alloc]init];
        people.name=dataArr[i];
        [self.dataArray addObject:people];
    }
}

#pragma mark - 初始化导航栏
- (void)initNavigation{
    
    //选择
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    
    [_selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_selectedBtn setTitle:@"完成" forState:UIControlStateSelected];
    
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:_selectedBtn];
    
    self.navigationItem.rightBarButtonItem =selectItem;
    
}

#pragma mark - 导航栏编辑/完成点击事件
- (void)selectedBtn:(UIButton *)btn{
    
    btn.selected=!btn.selected;
    
    if (btn.selected) {
        //全选显示
        _selectAllBtn.hidden=NO;
        
        //toolBar结算变成删除
        _deleteBtn.backgroundColor=[UIColor whiteColor];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:248/255.0 green:94/255.0 blue:97/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self.tableView reloadData];
    }else{
        //全选隐藏将点击状态变为未点击
        _selectAllBtn.hidden=YES;
        _selectAllBtn.selected=NO;
        
        //toolBar删除变结算
        _deleteBtn.backgroundColor=[UIColor colorWithRed:248/255.0 green:94/255.0 blue:97/255.0 alpha:1.0];
        [_deleteBtn setTitle:@"结算" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    //更改编辑状态
    self.tableView.editing=btn.selected;
    
    [self.tableView reloadData];
}

#pragma mark - 全选/取消全选点击事件
- (void)selectAllBtnClick:(UIButton *)btn{
    
    CGPoint abc = self.tableView.contentOffset;
    NSLog(@"%@",NSStringFromCGPoint(abc));
    btn.selected=!btn.selected;
    if (btn.selected) {
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        [self.deleteArray addObjectsFromArray:self.dataArray];
    }else{
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    [self.tableView setContentOffset:abc animated:YES];
}

#pragma mark --初始化底部工具栏
-(void)initBarView
{
    UIView *barView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    barView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:barView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [barView addSubview:lineView];

    _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 80, 30)];
    _deleteBtn.layer.cornerRadius=5;
    _deleteBtn.layer.masksToBounds=YES;
    _deleteBtn.layer.borderColor=[UIColor colorWithRed:248/255.0 green:94/255.0 blue:97/255.0 alpha:1.0].CGColor;
    _deleteBtn.layer.borderWidth=1;
    _deleteBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _deleteBtn.backgroundColor=[UIColor colorWithRed:248/255.0 green:94/255.0 blue:97/255.0 alpha:1.0];
    [_deleteBtn setTitle:@"结算" forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(previousButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:_deleteBtn];
    
    //全选
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectAllBtn.frame = CGRectMake(0, 10, 120, 30);
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_selectAllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectAllBtn.hidden=YES;
    [barView addSubview:_selectAllBtn];
    _selectAllBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 80);
    
}

#pragma mark - 底部工具栏结算/删除点击事件
- (void)previousButtonIsClicked:(UIButton *)btn{
    //编辑状态
    if(self.selectedBtn.selected){
        
        NSLog(@"删除");
       
        [self.dataArray removeObjectsInArray:self.deleteArray];
        [self.tableView reloadData];
    }else{
        NSLog(@"结算");
    }
    
}

#pragma mark - tableView初始化
- (UITableView *)tableView{
    
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    
        //可编辑状态下开启可点击功能(默认关闭)
        self.tableView.allowsSelectionDuringEditing=YES;
        
        //非编辑状态允许全选
//        self.tableView.allowsMultipleSelection=YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    //cell多选中时背景
    cell.multipleSelectionBackgroundView = [[UIView alloc]init];
    People *people=self.dataArray[indexPath.row];
//    cell.selectedBackgroundView = [[UIView alloc]init];
    cell.textLabel.text = people.name;
    if (self.tableView.editing) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - 哪几行可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
//        if (indexPath.row<5) {
//            return NO;
//        }else{
//            return YES;
//        }
        return YES;
    
}

#pragma mark - 编辑类型
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
//        多选
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }else{
    
        //非编辑状态侧滑删除功能
//        删除
        return UITableViewCellEditingStyleDelete;
    }
//    空
//    return UITableViewCellEditingStyleNone;
//    增加
//    return UITableViewCellEditingStyleInsert;
}

#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        [self.deleteArray addObject:self.dataArray[indexPath.row]];
        NSLog(@"选中了%@",indexPath);
    }
    
}

#pragma mark - cell多选取消点击事件
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        [self.deleteArray removeObject:self.dataArray[indexPath.row]];
        NSLog(@"取消选中");
    }
}

#pragma mark - 哪几行可进行移动操作
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<10) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 移动cell后的回调
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //获得原来  数据 在数组中的位置
    NSInteger oldN = sourceIndexPath.row;
    //获得新的 位置
    NSInteger newN = destinationIndexPath.row;
    
    //获得要移动的数据
    NSString* sg = _dataArray[oldN];
    
    //从原来位置删除了数据
    [_dataArray removeObjectAtIndex:oldN];
    
    //将数据添加到新的位置
    [_dataArray insertObject:sg atIndex:newN];
    
    [self.tableView reloadData];
    
}

#pragma mark - 侧滑删除回调事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"删除了%@",indexPath);
    }
}

#pragma mark - 修改侧滑删除文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"  删除";
}

- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        _deleteArray = [[NSMutableArray alloc]init];
    }
    return _deleteArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
