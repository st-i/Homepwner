//
//  BNRImageStore.m
//  Homepwner
//
//  Created by iStef on 22.12.16.
//  Copyright © 2016 Stefanov. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;
-(NSString *)imagePathForKey:(NSString *)key;

@end

@implementation BNRImageStore

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

+(instancetype)sharedStore
{
    static BNRImageStore *sharedStore=nil;
    
    /*if (!sharedStore) {
        sharedStore=[[self alloc]initPrivate];
    }*/
    
    //code below makes a thread-safe singleton. it ensures that code is run exactly once (in the case of multithreaded app)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore=[[self alloc]initPrivate];
    });
    
    return sharedStore;
}

//no one should call init
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [BNRImageStore sharedStore]" userInfo:nil];
    
    return nil;
}

//secret designated initializer
-(instancetype)initPrivate
{
    self=[super init];
    
    if (self) {
        _dictionary=[[NSMutableDictionary alloc]init];
        
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)clearCache:(NSNotification *)note
{
    NSLog(@"Flashing %lu images out of the cache.", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key]=image;
    
    //create full path for image
    NSString *imagePath=[self imagePathForKey:key];
    
    //turn image into JPEG data
    NSData *data=UIImageJPEGRepresentation(image, 0.5);
    
    //write it to full path
    [data writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
    //return [self.dictionary objectForKey:key];
    //return self.dictionary[key];
    
    //if possible, get it from the dictionary
    UIImage *result=self.dictionary[key];
    
    
    if (!result) {
        NSString *imagePath=[self imagePathForKey:key];
        //create UIImage object from file
        result=[UIImage imageWithContentsOfFile:imagePath];
        
        //if we found an image on the file system, place it into the cache
        if (result) {
            self.dictionary[key]=result;
        }else{
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    else{
        [self.dictionary removeObjectForKey:key];
    }
    
    NSString *imagePath=[self imagePathForKey:key];
    [[NSFileManager defaultManager]removeItemAtPath:imagePath error:nil];
}

@end
