//
//  SettingShowTranslationCell.h
//  Voice
//
//  Created by JiaLi on 11-9-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingShowTranslationCell : UITableViewCell {
    UILabel *_textLabelTrans;
    UIImageView* _selectedView;
}

@property (nonatomic, retain) IBOutlet UILabel* textLabelTrans;
@property (nonatomic, retain) IBOutlet UIImageView* selectedView;

@end
