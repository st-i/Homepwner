//
//  BNRItemStore.m
//  Homepwner
//
//  Created by iStef on 28.11.16.
//  Copyright © 2016 Stefanov. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@import CoreData;

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

//@property (strong, nonatomic) NSMutableArray *allAssetTypes;
//@property (strong, nonatomic) NSManagedObjectContext *context;
//@property (strong, nonatomic) NSManagedObjectModel *model;

@end

@implementation BNRItemStore

/*-(NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        
        NSEntityDescription *e=[NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        
        request.entity=e;
        
        NSError *error=nil;
        
        NSArray *result=[self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed!" format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes=[result mutableCopy];
    }
    
    //is this the first time the program is being run?
    if ([_allAssetTypes count]==0) {
        NSManagedObject *type;
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type=[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    return _allAssetTypes;
}*/

/*-(void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        
        NSEntityDescription *e=[NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
        request.entity=e;
        
        NSSortDescriptor *sd=[NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors=@[sd];
        
        NSError *error;
        NSArray *result=[self.context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"%@", [error localizedDescription]];
            
        }
        self.privateItems=[[NSMutableArray alloc]initWithArray:result];
    }
}*/

-(BOOL)saveChanges
{
    NSString *path=[self itemArchivePath];
    
    NSLog(@"%@", self.itemArchivePath);
    //return YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    
    /*NSError *error;
    
    BOOL successful=[self.context save:&error];
    
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;*/
}

-(NSString *)itemArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory=[documentDirectories firstObject];
    
    //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

+(instancetype)sharedStore
{
    static BNRItemStore *singleSharedStore=nil;
    
    //Do I need to create a singleSharedStore?
    if (!singleSharedStore) {
        singleSharedStore=[[BNRItemStore alloc]initPrivate];
    }
    
    return singleSharedStore;
}

//If a programmer calls [[BNRItemStore alloc]init], let him know the error of his ways
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore sharedStore]" userInfo:nil];
    
    return nil;
}

//Here is the real (secret) initializer
-(instancetype)initPrivate
{
    self=[super init];
    if (self) {
        //_privateItems=[[NSMutableArray alloc]init];
        NSString *path=[self itemArchivePath];
        _privateItems=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //if the array hadn't been saved previously, create a new empty one
        if (!_privateItems) {
            _privateItems=[[NSMutableArray alloc]init];
        }
        
        /*_model=[NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];
        
        NSString *path=self.itemArchivePath;
        NSURL *storeURL=[NSURL URLWithString:path];
        
        NSError *error=nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        _context=[[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator=psc;
        
        [self loadAllItems];*/
    }
    return self;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(BNRItem *)createItem
{
    //BNRItem *item=[BNRItem randomItem];
    BNRItem *item=[[BNRItem alloc]init];
    
    /*double order;
    
    if ([self.allItems count]==0) {
        order=1.0;
    }else{
        order=[[self.privateItems lastObject]orderingValue]+1.0;
    }
    NSLog(@"Adding after %lu items, order=%.2f", (unsigned long)[self.privateItems count], order);
    
    BNRItem *item=[NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:self.context];
    
    item.orderingValue=order;*/
    
    [self.privateItems addObject:item];
    
    return item;
}

-(void)removeItem:(BNRItem *)item
{
    NSString *key=item.itemKey;
    
    [[BNRImageStore sharedStore]deleteImageForKey:key];
    
    //[self.context deleteObject:item];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (fromIndex==toIndex) {
        return;
    }
    
    //Get pointer to object being moved so you can re-insert it
    BNRItem *item=self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    /*double lowerBound=0.0;
    
    if (toIndex>0) {
        lowerBound=[self.privateItems[(toIndex-1)] orderingValue];
    }else{
        lowerBound=[self.privateItems[1] orderingValue]-2.0;
    }
    
    double upperBound=0.0;
    
    if (toIndex<[self.privateItems count]-1) {
        upperBound=[self.privateItems[(toIndex+1)] orderingValue];
    }else{
        upperBound=[self.privateItems[(toIndex-1)] orderingValue]+2.0;
    }
    
    double newOrderValue=(lowerBound+upperBound)/2.0;
    NSLog(@"Moving to order %f", newOrderValue);
    item.orderingValue=newOrderValue;*/
    
}


@end
