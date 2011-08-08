//
//  SettingBubbleColorCell.h
//  Voice
//
//  Created by JiaLi on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingBubbleColorCell : UITableViewCell {
    UILabel* _label;
    UIView* _bubbleView;
    UILabel* _bubbleText;
}
@property(nonatomic, retain) IBOutlet UILabel* label;
@property(nonatomic, retain) IBOutlet UIView* bubbleView;
@property(nonatomic, retain) IBOutlet UILabel* bubbleText;

@end
