//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by iStef on 18.12.16.
//  Copyright © 2016 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRItem.h"

//@class BNRItem;

@interface BNRDetailViewController : UIViewController <UIViewControllerRestoration>

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void(^dismissBlock)(void);

-(instancetype)initForNewItem:(BOOL)isNew;

@end
