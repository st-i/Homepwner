//
//  BNRItemCell.h
//  Homepwner
//
//  Created by iStef on 06.01.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@interface BNRItemCell : NSObject
@interface BNRItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (copy, nonatomic) void(^actionBlock)(void);


@end
