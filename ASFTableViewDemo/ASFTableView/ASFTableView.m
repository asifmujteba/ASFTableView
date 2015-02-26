//
//  AMTableView.m
//  Patient Care
//
//  Created by Asif Mujteba on 31/01/2014.
//  Copyright (c) 2014 Asif Mujteba. All rights reserved.
//

#import "ASFTableView.h"
#import "ASFTableViewCell.h"
#import "ASFTableViewPrivateGlobals.h"

@interface ASFTableView () <UITableViewDataSource, UITableViewDelegate> {
    BOOL floatHeader;
}

@property (nonatomic, assign) NSUInteger headerHeight;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *rowData;
@property (nonatomic, retain) NSArray *weights, *innerWeights, *titlesArray;
@property (nonatomic, retain) NSDictionary *headerOptions;
@property (nonatomic, retain) UIView *selectedBackgroundView;
@property (nonatomic, retain) ASFTableViewCell *headerView;

@end

@implementation ASFTableView
@synthesize delegate, headerHeight;

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    delegate = nil;
    [_tableView release], _tableView = nil;
    [_headerView release], _headerView = nil;
    [_rowData release], _rowData = nil;
    [_weights release], _weights = nil;
    [_innerWeights release], _innerWeights = nil;
    [_titlesArray release], _titlesArray = nil;
    [_headerOptions release], _headerOptions = nil;
    [_selectedBackgroundView release], _selectedBackgroundView = nil;
    [super dealloc];
}

- (void)initialize {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _tableView.translatesAutoresizingMaskIntoConstraints = YES;
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_tableView];
}

- (void)setBounces:(BOOL)aBounces {
    [_tableView setBounces:aBounces];
}

- (void)setSelectionColor:(UIColor *)aColor {
    [_selectedBackgroundView release], _selectedBackgroundView = nil;
    
    if (aColor) {
        _selectedBackgroundView = [[UIView alloc] init];
        [_selectedBackgroundView setBackgroundColor:aColor];
    }
}

- (NSDictionary *)selectedRowData {
    return [_rowData objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
}

- (NSUInteger)selectedRowIndex {
    return [[_tableView indexPathForSelectedRow] row];
}

- (void)setTitles:(NSArray *)aArr WithWeights:(NSArray *)aWeights WithOptions:(NSDictionary *)aOptions
        WitHeight:(NSUInteger)aHeight Floating:(BOOL)aFloat {
    [self setTitles:aArr WithWeights:aWeights WithInnerWeights:nil WithOptions:aOptions WitHeight:aHeight Floating:aFloat];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (_titlesArray) {
        [self setTitles:_titlesArray WithWeights:_weights WithOptions:_headerOptions WitHeight:headerHeight Floating:floatHeader];
    }
}

- (void)setTitles:(NSArray *)aArr WithWeights:(NSArray *)aWeights WithInnerWeights:(NSArray *)aInnerWeights
      WithOptions:(NSDictionary *)aOptions WitHeight:(NSUInteger)aHeight Floating:(BOOL)aFloat {
    
    floatHeader = aFloat;
    self.weights = aWeights;
    self.headerHeight = aHeight;
    self.innerWeights = aInnerWeights;
    self.titlesArray = aArr;
    self.HeaderOptions = aOptions;
    
    ASFTableViewCell *hView = [[ASFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HEADER"];
    [hView setFrame:CGRectMake(0, 0, [self frame].size.width, aHeight)];
    
    NSMutableArray *newArr = [[NSMutableArray alloc] initWithCapacity:[aArr count]];
    for (int i=0; i<[aWeights count] && i<[aArr count]; i++) {
        [newArr addObject:@{kASF_CELL_TITLE : [aArr objectAtIndex:i], kASF_CELL_WEIGHT : [aWeights objectAtIndex:i]}];
    }
    [hView setMinHeight:aHeight];
    [hView setColumns:newArr Options:aOptions IsInnerRow:false];
    [newArr release];
    
    self.headerView = hView;
    [hView release];
    
    if (!floatHeader) {
        _tableView.tableHeaderView = _headerView;
    }
    else {
        _tableView.tableHeaderView = nil;
    }
}

- (void)setRows:(NSArray *)aArr {
    [_rowData release], _rowData = nil;
    
    _rowData = [[NSMutableArray alloc] initWithCapacity:[aArr count]];
    for (int i=0; i<[aArr count]; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[aArr objectAtIndex:i]];
        NSArray *cols = [dict valueForKey:kASF_ROW_CELLS];
        
        NSMutableArray *newCols = [[NSMutableArray alloc] initWithCapacity:[cols count]];
        for (int i=0; i<[cols count]; i++) {
            NSMutableDictionary *rowDict = [[NSMutableDictionary alloc] initWithDictionary:[cols objectAtIndex:i]];
            
            if ([dict valueForKey:kASF_IS_INNER_ROW]) {
                [rowDict setValue:[_innerWeights objectAtIndex:i] forKey:kASF_CELL_WEIGHT];
            }
            else {
                [rowDict setValue:[_weights objectAtIndex:i] forKey:kASF_CELL_WEIGHT];
            }
            
            if ([[rowDict valueForKey:kASF_CELL_IS_KEY] boolValue]) {
                [rowDict setValue:[dict valueForKey:[rowDict valueForKey:kASF_CELL_TITLE]] forKey:kASF_CELL_TITLE];
            }
            
            [newCols addObject:rowDict];
            [rowDict release];
        }
        
        [dict setValue:newCols forKey:kASF_ROW_CELLS];
        [newCols release];
        
        [_rowData addObject:dict];
        [dict release];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rowData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ASFTableViewCellSimple";
    
    ASFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[[ASFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] autorelease];
        [cell setFrame:CGRectMake(0, 0, _tableView.frame.size.width, 44)];
        [cell setSelectedBackgroundView:_selectedBackgroundView];
    }
    
    NSDictionary *rowDict = [_rowData objectAtIndex:indexPath.row];
    
    [cell setRowId:[rowDict valueForKey:kASF_ROW_ID]];
    [cell setColumns:[rowDict valueForKey:kASF_ROW_CELLS] Options:[rowDict valueForKey:kASF_ROW_OPTIONS]
          IsInnerRow:[[rowDict valueForKey:kASF_IS_INNER_ROW] boolValue]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (floatHeader && _headerView) {
        return [_headerView frame].size.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (floatHeader && _headerView) {
        return _headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat maxHeight = kDEFAULT_MIN_HEIGHT;
    
    NSDictionary *rowDict = [_rowData objectAtIndex:indexPath.row];
    NSArray *aArr = [rowDict valueForKey:kASF_ROW_CELLS];
    NSDictionary *dictOptions = [rowDict valueForKey:kASF_ROW_OPTIONS];
    
    for (int i=0; i<[aArr count]; i++) {
        NSDictionary *dict = [aArr objectAtIndex:i];
        NSString *text = [dict valueForKey:kASF_CELL_TITLE];
        if (text == (id)[NSNull null]) { text = @""; }
        
        float CELL_CONTENT_WIDTH = [[dict valueForKey:kASF_CELL_WEIGHT] floatValue] * [_tableView frame].size.width;
        int CELL_CONTENT_MARGIN = 0;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        int fontSize = [[dict valueForKey:kASF_OPTION_CELL_TEXT_FONT_SIZE] intValue];
        if (!fontSize) { fontSize = [[dictOptions valueForKey:kASF_OPTION_CELL_TEXT_FONT_SIZE] intValue]; }
        if (!fontSize) { fontSize = kDEFAULT_FONT_SIZE; }
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize]
                       constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, kDEFAULT_MIN_HEIGHT);
        height = height + (CELL_CONTENT_MARGIN * 2);
        
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    
    return maxHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([delegate respondsToSelector:@selector(ASFTableView:DidSelectRow:WithRowIndex:)]) {
        NSDictionary *rowDict = [_rowData objectAtIndex:indexPath.row];
        [delegate ASFTableView:self DidSelectRow:rowDict WithRowIndex:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([delegate respondsToSelector:@selector(ASFTableView:DidScroll:)]) {
        [delegate ASFTableView:self DidScroll:scrollView];
    }
}

@end
