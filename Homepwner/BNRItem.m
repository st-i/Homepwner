//
//  BNRItem.m
//  RandomItems
//
//  Created by iStef on 10.11.16.
//  Copyright © 2016 St. All rights reserved.
//

/*Chapter 3_______________________________________________________________________*/

#import "BNRItem.h"

@implementation BNRItem

-(void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize=image.size;
    
    //the rectangle of the thumbnail
    CGRect newRect=CGRectMake(0, 0, 40, 40);
    
    //figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio=MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
    //create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    //create a path that is a rounded rectangle
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    //make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    //center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width=ratio*origImageSize.width;
    projectRect.size.height=ratio*origImageSize.height;
    //projectRect.origin.x=newRect.origin.x;
    //projectRect.origin.y=newRect.origin.y;
    projectRect.origin.x=(newRect.size.width-projectRect.size.width)/2.0;
    projectRect.origin.y=(newRect.size.height-projectRect.size.height)/2.0;
    
    //draw the image on it
    [image drawInRect:projectRect];
    
    //get the image from the image context; keep it as our thumbnail
    UIImage *smallImage=UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail=smallImage;
    
    //cleanup image context resources; we're done
    UIGraphicsEndImageContext();
}

//it needs to delete underscores
//@synthesize containedItemm, container, itemName, serialNumber, dateCreated, valueInDollars;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self) {
        _itemName=[aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber=[aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated=[aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey=[aDecoder decodeObjectForKey:@"itemKey"];
        _valueInDollars=[aDecoder decodeIntForKey:@"valueInDollars"];
        _thumbnail=[aDecoder decodeObjectForKey:@"thumbnail"];
    }
    return self;
}

+(instancetype)randomItem
{
    NSArray *randomAdjectiveList=@[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList=@[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex=arc4random()%[randomAdjectiveList count];
    NSInteger nounIndex=arc4random()%[randomNounList count];
    
    NSString *randomName=[NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex], randomNounList[nounIndex]];
    
    int randomValue=arc4random()%100;
    
    NSString *randomSerialNumber=[NSString stringWithFormat:@"%c%c%c%c%c", '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10];
    
    BNRItem *newItem=[[self alloc]initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    //call the superclass's designated initializer
    self=[super init];
    
    //did the superclass's designated initializer succeed?
    if (self) {
        //give the instance variables initial values
        _itemName=name;
        _serialNumber=sNumber;
        _valueInDollars=value;
        //set _dateCreated to the current date and time
        _dateCreated=[[NSDate alloc]init];
    }
    
    //create an NSUUID object and get its string represenatation
    NSUUID *uuid=[[NSUUID alloc]init];
    NSString *key=[uuid UUIDString];
    _itemKey=key;
    
    
    //return the address of the newly initialized object
    return self;
}

-(instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

-(instancetype)init
{
    return [self initWithItemName:@"Item"];
}

//-(void)setContainedItem:(BNRItem *)containedItem
//{
    //_containedItemm=containedItem;
    //self.containedItemm.container=self;
//}

//-(void)setItemName:(NSString *)str
//{
    //_itemName=str;
//}

//-(NSString *)itemName
//{
    //return _itemName;
//}

//-(void)setSerialNumber:(NSString *)str
//{
    //_serialNumber=str;
//}

//-(NSString *)serialNumber
//{
    //return _serialNumber;
//}

//-(void)setValueInDollars:(int)v
//{
    //_valueInDollars=v;
//}

//-(int)valueInDollars
//{
    //return _valueInDollars;
//}

//-(NSDate *)dateCreated
//{
    //return _dateCreated;
//}

-(NSString *)description
{
    NSString *descriptionString=[[NSString alloc]initWithFormat:@"%@ (%@): Worth $%d, recorded on %@.", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}

-(void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

//-(void)setContainedItem:(BNRItem *)item;
//{
    //_containedItem=item;
    //when given an item to contain, contained item will be given a pointer to its contailer
    //item.container=self;
//}

//-(BNRItem *)containedItem
//{
    //return _containedItem;
//}

//-(void)setContainer:(BNRItem *)item
//{
    //_container=item;
//}

//-(BNRItem *)container
//{
    //return _container;
//}

@end

/*Chapter 2, Silver Challenge_______________________________________________________________________

#import "BNRItem.h"

@implementation BNRItem

+(instancetype)randomItem
{
    NSArray *randomAdjectiveList=@[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList=@[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex=arc4random()%[randomAdjectiveList count];
    NSInteger nounIndex=arc4random()%[randomNounList count];
    
    NSString *randomName=[NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex], randomNounList[nounIndex]];
    
    int randomValue=arc4random()%100;
    
    NSString *randomSerialNumber=[NSString stringWithFormat:@"%c%c%c%c%c", '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10];
    
    BNRItem *newItem=[[self alloc]initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    //call the superclass's designated initializer
    self=[super init];
    
    //did the superclass's designated initializer succeed?
    if (self) {
        //give the instance variables initial values
        _itemName=name;
        _serialNumber=sNumber;
        _valueInDollars=value;
        //set _dateCreated to the current date and time
        _dateCreated=[[NSDate alloc]init];
    }
    //return the address of the newly initialized object
    return self;
}

-(instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

-(instancetype)initWithItemName:(NSString *)name andSerialNumber:(NSString *)serNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:serNumber];
}

-(instancetype)init
{
    return [self initWithItemName:@"Item"];
}

-(void)setItemName:(NSString *)str
{
    _itemName=str;
}

-(NSString *)itemName
{
    return _itemName;
}

-(void)setSerialNumber:(NSString *)str
{
    _serialNumber=str;
}

-(NSString *)serialNumber
{
    return _serialNumber;
}

-(void)setValueInDollars:(int)v
{
    _valueInDollars=v;
}

-(int)valueInDollars
{
    return _valueInDollars;
}

-(NSDate *)dateCreated
{
    return _dateCreated;
}

-(NSString *)description
{
    NSString *descriptionString=[[NSString alloc]initWithFormat:@"%@ (%@): Worth $%d, recorded on %@.", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}

@end*/

/*Chapter 2_______________________________________________________________________

#import "BNRItem.h"

@implementation BNRItem

+(instancetype)randomItem
{
    NSArray *randomAdjectiveList=@[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList=@[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex=arc4random()%[randomAdjectiveList count];
    NSInteger nounIndex=arc4random()%[randomNounList count];
    
    NSString *randomName=[NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex], randomNounList[nounIndex]];
    
    int randomValue=arc4random()%100;
    
    NSString *randomSerialNumber=[NSString stringWithFormat:@"%c%c%c%c%c", '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10];
    
    BNRItem *newItem=[[self alloc]initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    //call the superclass's designated initializer
    self=[super init];
    
    //did the superclass's designated initializer succeed?
    if (self) {
        //give the instance variables initial values
        _itemName=name;
        _serialNumber=sNumber;
        _valueInDollars=value;
        //set _dateCreated to the current date and time
        _dateCreated=[[NSDate alloc]init];
    }
    //return the address of the newly initialized object
    return self;
}

-(instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

-(instancetype)init
{
    return [self initWithItemName:@"Item"];
}

-(void)setItemName:(NSString *)str
{
    _itemName=str;
}

-(NSString *)itemName
{
    return _itemName;
}

-(void)setSerialNumber:(NSString *)str
{
    _serialNumber=str;
}

-(NSString *)serialNumber
{
    return _serialNumber;
}

-(void)setValueInDollars:(int)v
{
    _valueInDollars=v;
}

-(int)valueInDollars
{
    return _valueInDollars;
}

-(NSDate *)dateCreated
{
    return _dateCreated;
}

-(NSString *)description
{
    NSString *descriptionString=[[NSString alloc]initWithFormat:@"%@ (%@): Worth $%d, recorded on %@.", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}

@end*/
