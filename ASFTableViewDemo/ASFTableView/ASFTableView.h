//
//  AMTableView.h
//  Patient Care
//
//  Created by Asif Mujteba on 31/01/2014.
//  Copyright (c) 2014 Asif Mujteba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASFTableViewPublicGlobals.h"

@class ASFTableView;

@protocol ASFTableViewDelegate <NSObject>

@optional
- (void)ASFTableView:(ASFTableView *)tableView DidSelectRow:(NSDictionary *)rowDict WithRowIndex:(NSUInteger)rowIndex;
- (void)ASFTableView:(ASFTableView *)tableView DidScroll:(UIScrollView *)aScrollView;

@end



@interface ASFTableView : UIView

@property (nonatomic, assign) id<ASFTableViewDelegate> delegate;

/**
 Get the Selected Row's NSDictionary
 @return NSDictionary *
 */
- (NSDictionary *)selectedRowData;

/**
 Get the Selected Row Index
 @return NSUInteger
 */
- (NSUInteger)selectedRowIndex;

/**
 Set Bounes Property of TableView
 @param aBounces
 Boolean Value
 @return void
 */
- (void)setBounces:(BOOL)aBounces;

/**
Color to set when a row is in selected state
 @param aColor
 The Color Value to set
 @return void
 */
- (void)setSelectionColor:(UIColor *)aColor;

/**
 Set Various Table Values
 @param aArr
 NSArray of NSString values to set in columns of header row
 @param aWeights
 NSArray of floats X where 0 < X >= 1, Percentage width of column relative to total Width of table
 @param aOptions
 NSDictionary containing customization values, See ASFTableViewPublicGlobals for available options to set
 @param aHeight
 NSUInteger minimum height of Header View
 @param aFloat
 BOOL value if Header should stick to the top of float away while scrolling
 @return void
 */
- (void)setTitles:(NSArray *)aArr WithWeights:(NSArray *)aWeights WithOptions:(NSDictionary *)aOptions
        WitHeight:(NSUInteger)aHeight Floating:(BOOL)aFloat;

/**
 Set Various Table Values
 @param aArr
 NSArray of NSString values to set in columns of header row
 @param aWeights
 NSArray of floats X where 0 < X >= 1, Percentage width of column relative to total Width of table
 @param aInnerWeights
 NSArray of floats X where 0 < X >= 1, Percentage width of column of Inner Row relative to total Width of Inner Row
 @param aOptions
 NSDictionary containing customization values, See ASFTableViewPublicGlobals for available options to set
 @param aHeight
 NSUInteger minimum height of Header View
 @param aFloat
 BOOL value if Header should stick to the top of float away while scrolling
 @return void
 */
- (void)setTitles:(NSArray *)aArr WithWeights:(NSArray *)aWeights WithInnerWeights:(NSArray *)aInnerWeights
      WithOptions:(NSDictionary *)aOptions WitHeight:(NSUInteger)aHeight Floating:(BOOL)aFloat;

/**
 Set Rows of the Table
 @param aArr
 NSArray of dictionaries containing row data identified with keys defined in ASFTableViewPublicGlobals
 @return void
 */
- (void)setRows:(NSArray *)aArr;

@end
