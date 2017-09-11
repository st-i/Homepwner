//
//  BNRItem.h
//  RandomItems
//
//  Created by iStef on 10.11.16.
//  Copyright © 2016 St. All rights reserved.
//

/*Chapter 3_______________________________________________________________________*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItem : NSObject <NSCoding>
//{
    //int _valueInDollars;
    //NSString *_itemName;
    //NSString *_serialNumber;
    //NSDate *_dateCreated;
    
    //BNRItem *_containedItem;
    //__weak BNRItem *_container;
//}

//@property (nonatomic, strong) BNRItem *containedItemm;
//@property (nonatomic, weak) BNRItem *container;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, copy) NSString *itemKey;

@property (strong, nonatomic) UIImage *thumbnail;

-(void)setThumbnailFromImage:(UIImage *)image;

+(instancetype)randomItem;

//Designated initializer for BNRItem
-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;

//-(void)setItemName:(NSString *)str;
//-(NSString *)itemName;

//-(void)setSerialNumber:(NSString *)str;
//-(NSString *)serialNumber;

//-(void)setValueInDollars:(int)v;
//-(int)valueInDollars;

//-(NSDate *)dateCreated;

//-(void)setContainedItem:(BNRItem *)item;
//-(BNRItem *)containedItem;

//-(void)setContainer:(BNRItem *)item;
//-(BNRItem *)container;

@end

/*Chapter 2, Silver Challenge_______________________________________________________________________

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    int _valueInDollars;
    NSString *_itemName;
    NSString *_serialNumber;
    NSDate *_dateCreated;
}

+(instancetype)randomItem;

//Designated initializer for BNRItem
-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;

-(instancetype)initWithItemName:(NSString *)name andSerialNumber:(NSString *)serNumber;

-(void)setItemName:(NSString *)str;
-(NSString *)itemName;

-(void)setSerialNumber:(NSString *)str;
-(NSString *)serialNumber;

-(void)setValueInDollars:(int)v;
-(int)valueInDollars;

-(NSDate *)dateCreated;

@end*/

/*Chapter 2_______________________________________________________________________

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    int _valueInDollars;
    NSString *_itemName;
    NSString *_serialNumber;
    NSDate *_dateCreated;
}

+(instancetype)randomItem;

//Designated initializer for BNRItem
-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;

-(void)setItemName:(NSString *)str;
-(NSString *)itemName;

-(void)setSerialNumber:(NSString *)str;
-(NSString *)serialNumber;

-(void)setValueInDollars:(int)v;
-(int)valueInDollars;

-(NSDate *)dateCreated;

@end*/
