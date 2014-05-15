ASFTableView
============

A customizable Web like multi column tableview for iOS with header and inner rows 


![alt tag](http://s17.postimg.org/gavj6jzhr/demo1.png)


USAGE:

````
#import "ASFTableView.h"
````

* Add UIView to your view and set its class to ASFTableView

````
NSArray *cols = @[@"Person ID",@"Person Name",@"Phone Number",@"Sex"];
    NSArray *weights = @[@(0.15f),@(0.5f),@(0.25f),@(0.1f)];
    NSDictionary *options = @{kASF_OPTION_CELL_TEXT_FONT_SIZE : @(16),
                              kASF_OPTION_CELL_TEXT_FONT_BOLD : @(true),
                              kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor],
                              kASF_OPTION_CELL_BORDER_SIZE : @(2.0),
                              kASF_OPTION_BACKGROUND : [UIColor colorWithRed:239/255.0 green:244/255.0 blue:254/255.0 alpha:1.0]};
    
    [_mASFTableView setDelegate:self];
    [_mASFTableView setBounces:NO];
    [_mASFTableView setSelectionColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f]];
    [_mASFTableView setTitles:cols
                     WithWeights:weights
                     WithOptions:options
                       WitHeight:32 Floating:YES];


    for (int i=0; i<25; i++) {
        [_rowsArray addObject:@{
                kASF_ROW_ID :
        @(i),
                                      
                kASF_ROW_CELLS :
        @[@{kASF_CELL_TITLE : @"Sample ID", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
        @{kASF_CELL_TITLE : @"Sample Name", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentLeft)},
        @{kASF_CELL_TITLE : @"Sample Phone No.", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
        @{kASF_CELL_TITLE : @"Sample Gender", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                      
                kASF_ROW_OPTIONS :
        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
        kASF_OPTION_CELL_PADDING : @(5),
        kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                      
        @"some_other_data" : @(123)}];
    }
    
    [_mASFTableView setRows:_rowsArray];
    
````
