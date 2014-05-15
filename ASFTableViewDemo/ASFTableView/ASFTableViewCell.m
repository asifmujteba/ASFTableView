//
//  ASFTableViewCell.m
//  Patient Care
//
//  Created by Asif Mujteba on 01/02/2014.
//  Copyright (c) 2014 Asif Mujteba. All rights reserved.
//

#import "ASFTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ASFTableViewPrivateGlobals.h"
#import "ASFTableViewPublicGlobals.h"
#import "ASFLabel.h"

@interface ASFTableViewCell () <UITextViewDelegate>

@property (nonatomic, retain) NSDictionary *dictOptions;
@property (nonatomic, retain) NSMutableArray *arrLabels, *arrTextViews;

@end

@implementation ASFTableViewCell
@synthesize minHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _arrLabels = [[NSMutableArray alloc] init];
        _arrTextViews = [[NSMutableArray alloc] init];
        minHeight = kDEFAULT_MIN_HEIGHT;
    }
    return self;
}

- (void)dealloc {
    [_dictOptions release], _dictOptions = nil;
    [_arrLabels release], _arrLabels = nil;
    [_arrTextViews release], _arrTextViews = nil;
    [super dealloc];
}

- (void)setColumns:(NSArray *)aArr Options:(NSDictionary *)aOptions IsInnerRow:(BOOL)isInnerRow {
    self.dictOptions = aOptions;
    
    UIColor *bgColor = [_dictOptions valueForKey:kASF_OPTION_BACKGROUND];
    if (!bgColor) { bgColor = [UIColor lightGrayColor]; }
    self.contentView.backgroundColor = bgColor;
    
    // Count total Editable Fields
    int editablesCount = 0;
    for (int i=0; i<[aArr count]; i++) {
        NSDictionary *cellDict = [aArr objectAtIndex:i];
        BOOL isEditable = [[cellDict valueForKey:kASF_CELL_IS_EDITABLE] boolValue];
        if (isEditable) {
            editablesCount++;
        }
    }
    
    int innerMargin = 300;
    int dx= 0, lblCount = 0, txtCount = 0;
    if (isInnerRow) {
        dx = innerMargin;
    }
    
    for (int i=0; i<[aArr count]; i++) {
        NSDictionary *cellDict = [aArr objectAtIndex:i];
        
        BOOL isEditable = [[cellDict valueForKey:kASF_CELL_IS_EDITABLE] boolValue];
        
        NSString *title = [cellDict valueForKey:kASF_CELL_TITLE];
        if (!title || title == (id)[NSNull null]) { title = @""; }
        
        float weight = [[cellDict valueForKey:kASF_CELL_WEIGHT] floatValue];
        if (weight <= 0 || weight > 1) { weight = 1.0f/[aArr count]; }
        
        int width = self.frame.size.width;
        if (isInnerRow) {
            width -= innerMargin;
        }
        
        width = width * weight;
        
        
        UIColor *bgColor = [cellDict valueForKey:kASF_OPTION_CELL_BACKGROUND];
        if (!bgColor) { bgColor = [_dictOptions valueForKey:kASF_OPTION_CELL_BACKGROUND]; }
        if (!bgColor) { bgColor = [UIColor clearColor]; }
        
        UIColor *txtColor = [cellDict valueForKey:kASF_OPTION_CELL_TEXT_COLOR];
        if (!txtColor) { txtColor = [_dictOptions valueForKey:kASF_OPTION_CELL_TEXT_COLOR]; }
        if (!txtColor) { txtColor = [UIColor blackColor]; }
        
        BOOL fontBold = [[cellDict valueForKey:kASF_OPTION_CELL_TEXT_FONT_BOLD] boolValue];
        if (!fontBold) { fontBold = [[_dictOptions valueForKey:kASF_OPTION_CELL_TEXT_FONT_BOLD] boolValue]; }
        
        int fontSize = [[cellDict valueForKey:kASF_OPTION_CELL_TEXT_FONT_SIZE] intValue];
        if (!fontSize) { fontSize = [[_dictOptions valueForKey:kASF_OPTION_CELL_TEXT_FONT_SIZE] intValue]; }
        if (!fontSize) { fontSize = kDEFAULT_FONT_SIZE; }
        
        UIFont *textFont = nil;
        if (fontBold) {
            textFont = [UIFont boldSystemFontOfSize:fontSize];
        }
        else {
            textFont = [UIFont systemFontOfSize:fontSize];
        }
        
        UIColor *borderColor = [cellDict valueForKey:kASF_OPTION_CELL_BORDER_COLOR];
        if (!borderColor) { borderColor = [_dictOptions valueForKey:kASF_OPTION_CELL_BORDER_COLOR]; }
        if (!borderColor) { borderColor = [UIColor darkGrayColor]; }
        
        CGFloat borderSize = [[cellDict valueForKey:kASF_OPTION_CELL_BORDER_SIZE] floatValue];
        if (!borderSize) { borderSize = [[_dictOptions valueForKey:kASF_OPTION_CELL_BORDER_SIZE] floatValue]; }
        if (!borderSize) { if(isEditable) { borderSize = 3.0; } else { borderSize = 1.0; } }
        
        if (isEditable) {
            BOOL createNewView = true;
            if (txtCount < [_arrTextViews count]) { createNewView = false; }
            
            UITextView *textView;
            if (createNewView) {
                textView = [[UITextView alloc] init];
            }
            else {
                textView = [_arrTextViews objectAtIndex:txtCount];
            }
            
            [textView setTag:[[cellDict valueForKey:kASF_CELL_TEXTVIEW_TAG] intValue]];
            [textView setDelegate:[cellDict valueForKey:kASF_CELL_TEXTVIEW_DELEGATE]];
            [textView setEditable:YES];
            [textView setFrame:CGRectMake(dx+5, 5, width-10, self.frame.size.height-10)];
            [textView setText:title];
            [textView setBackgroundColor:bgColor];
            [textView setTextColor:txtColor];
            [textView setFont:textFont];
            
            textView.layer.borderColor = borderColor.CGColor;
            textView.layer.borderWidth = borderSize;
            
            textView.layer.cornerRadius = 5;
            textView.clipsToBounds = YES;
            
            if (createNewView) {
                [self addSubview:textView];
                [_arrTextViews addObject:textView];
                [textView release];
            }
            
            txtCount++;
        }
        else {
            BOOL createNewLabel = true;
            if (lblCount < [_arrLabels count]) { createNewLabel = false; }
            
            ASFLabel *lbl;
            if (createNewLabel) {
                lbl = [[ASFLabel alloc] init];
            }
            else {
                lbl = [_arrLabels objectAtIndex:lblCount];
            }
            
            [lbl setFrame:CGRectMake(dx, 0, width, self.frame.size.height)];
            [lbl setText:title];
            [lbl setNumberOfLines:0];
            [lbl setBackgroundColor:bgColor];
            [lbl setTextColor:txtColor];
            [lbl setFont:textFont];
            
            int txtAlignment = [[cellDict valueForKey:kASF_OPTION_CELL_TEXT_ALIGNMENT] intValue];
            if (![cellDict valueForKey:kASF_OPTION_CELL_TEXT_ALIGNMENT]) {
                txtAlignment = [[_dictOptions valueForKey:kASF_OPTION_CELL_TEXT_ALIGNMENT] intValue];
                if (![_dictOptions valueForKey:kASF_OPTION_CELL_TEXT_ALIGNMENT]) { txtAlignment = NSTextAlignmentCenter; }
            }
            [lbl setTextAlignment:txtAlignment];
            
            int padding = [[cellDict valueForKey:kASF_OPTION_CELL_PADDING] intValue];
            if (!padding) { padding = [[_dictOptions valueForKey:kASF_OPTION_CELL_PADDING] intValue]; }
            if (!padding) { padding = 0; }
            [lbl setPadding:padding];
            
            lbl.layer.borderColor = borderColor.CGColor;
            lbl.layer.borderWidth = borderSize;
            
            if (createNewLabel) {
                [self addSubview:lbl];
                [_arrLabels addObject:lbl];
                [lbl release];
            }
            
            lblCount++;
        }
        
        dx += width;
    }
    
    CGFloat maxHeight = minHeight;
    for (int i=0; i<[_arrLabels count]; i++) {
        UILabel *lbl = [_arrLabels objectAtIndex:i];
        NSString *text = [lbl text];
        float CELL_CONTENT_WIDTH = [lbl frame].size.width;
        int CELL_CONTENT_MARGIN = 0;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:[[lbl font] pointSize]]
                       constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, minHeight);
        height = height + (CELL_CONTENT_MARGIN * 2);
        
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    
    for (int i=0; i<[_arrLabels count]; i++) {
        UILabel *lbl = [_arrLabels objectAtIndex:i];
        CGRect fr = lbl.frame;
        [lbl setFrame:CGRectMake(fr.origin.x, fr.origin.y, fr.size.width, maxHeight)];
    }
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//#pragma mark - UITextViewDelegate
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    CGPoint pointInTable = [[textView superview] convertPoint:textView.frame.origin toView:tableView];
//    CGPoint contentOffset = tableView.contentOffset;
//    
//    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height);
//    
//    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
//    
//    [tableView setContentOffset:contentOffset animated:YES];
//    
//    return YES;
//}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView; {
//    [textView resignFirstResponder];
//    
//    if ([textView.superview.superview isKindOfClass:[UITableViewCell class]]) {
//        
//        UITableViewCell *cell = (UITableViewCell*)textView.superview.superview;
//        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
//        
//        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
//    }
//    
//    return YES;
//}

@end
