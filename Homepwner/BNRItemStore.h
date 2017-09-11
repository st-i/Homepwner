//
//  BNRItemStore.h
//  Homepwner
//
//  Created by iStef on 28.11.16.
//  Copyright © 2016 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property(nonatomic, readonly) NSArray *allItems;

//-(NSArray *)allAssetTypes;

+(instancetype)sharedStore;
-(BNRItem *)createItem;
-(void)removeItem:(BNRItem *)item;
-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
-(BOOL)saveChanges;


@end
