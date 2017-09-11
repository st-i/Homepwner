//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by iStef on 28.11.16.
//  Copyright © 2016 Stefanov. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemsViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>

@property (strong, nonatomic) UIPopoverController *imagePopover;

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

-(NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSString *identifier=nil;
    
    //return an identifier of the given NSIndexPath, in case next time the data source changes
    if (idx && view) {
        BNRItem *item=[[BNRItemStore sharedStore]allItems][idx.row];
        identifier=item.itemKey;
    }
    return identifier;
}

-(NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath=nil;
    
    if (identifier && view) {
        NSArray *items=[[BNRItemStore sharedStore]allItems];
        for (BNRItem *item in items) {
            if ([identifier isEqualToString:item.itemKey]) {
                int row=[items indexOfObjectIdenticalTo:item];
                indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.isEditing forKey:@"UITableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing=[coder decodeBoolForKey:@"UITableViewIsEditing"];
    [super decodeRestorableStateWithCoder:coder];
}

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc]init];
}

-(void)dealloc
{
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

-(void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary=@{
                               UIContentSizeCategoryExtraSmall:@44,
                               UIContentSizeCategorySmall:@44,
                               UIContentSizeCategoryMedium:@44,
                               UIContentSizeCategoryLarge:@44,
                               UIContentSizeCategoryExtraLarge:@55,
                               UIContentSizeCategoryExtraExtraLarge:@65,
                               UIContentSizeCategoryExtraExtraExtraLarge:@75
                               };
    }
    
    NSString *userSize=[[UIApplication sharedApplication]preferredContentSizeCategory];
    
    NSNumber *cellHeight=cellHeightDictionary[userSize];
    
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    //load the nib file
    UINib *nib=[UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    //register this nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
    self.tableView.restorationIdentifier=@"BNRItemsViewControllerTableView";
    
    //UIView *header=self.headerView;
    //[self.tableView setTableHeaderView:header];
    
}

-(instancetype)init
{
    //Call the superclass's designated initializer
    self=[super initWithStyle:UITableViewStylePlain];
    if (self) {
        //for (int i=0; i<5; i++) {
          //  [[BNRItemStore sharedStore] createItem];
        //}
        UINavigationItem *navItem=self.navigationItem;
        //navItem.title=@"Homepwner";
        
        navItem.title=NSLocalizedString(@"Homepwner", @"Name of application");
        
        self.restorationIdentifier=NSStringFromClass([self class]);
        self.restorationClass=[self class];
        
        //Create a new bar button item that will send addNewItem: to BNRItemsViewController
        UIBarButtonItem *bbi=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        navItem.rightBarButtonItem=bbi;
        
        navItem.leftBarButtonItem=self.editButtonItem;
        
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        [nc addObserver:self selector:@selector(localeChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
        
    }
    return self;
}

-(void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

+(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore]allItems]count];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover=nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    BNRItemCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    
    NSArray *items=[[BNRItemStore sharedStore]allItems];
    BNRItem *item=items[indexPath.row];
    
    //cell.textLabel.text=[item description];
    cell.nameLabel.text=item.itemName;
    cell.serialNumberLabel.text=item.serialNumber;
    
    //create a number formatter for currency
    static NSNumberFormatter *currencyFormatter=nil;
    if (currencyFormatter==nil) {
        currencyFormatter=[[NSNumberFormatter alloc]init];
        currencyFormatter.numberStyle=NSNumberFormatterCurrencyStyle;
    }
    cell.valueLabel.text=[currencyFormatter stringFromNumber:@(item.valueInDollars)];
    //cell.valueLabel.text=[NSString stringWithFormat:@"$%d", item.valueInDollars];
    
    cell.thumbnailView.image=item.thumbnail;
    
    if (item.valueInDollars<50) {
        cell.valueLabel.textColor=[UIColor redColor];
    }else{
        cell.valueLabel.textColor=[UIColor colorWithRed:0.03 green:0.63 blue:0.13 alpha:1.0];
    }
    
    __weak BNRItemCell *weakCell=cell;
    
    cell.actionBlock=^{
        NSLog(@"Going to show image for %@", item);
        
        BNRItemCell *strongCell=weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
            NSString *itemKey=item.itemKey;
            
            //if there is no image, we don't need to display anything
            UIImage *img=[[BNRImageStore sharedStore]imageForKey:itemKey];
            
            if (!img) {
                return;
            }
            
            //make a rectangele for the frame of the thumbnail relative to our table view
            //CGRect rect=[self.view convertRect:cell.thumbnailView.bounds fromView:cell.thumbnailView];
            CGRect rect=[self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            //create a new BNRImageViewController and set its image
            BNRImageViewController *ivc=[[BNRImageViewController alloc]init];
            
            ivc.image=img;
            
            //present a 600x600 popover from the rect
            self.imagePopover=[[UIPopoverController alloc]initWithContentViewController:ivc];
            
            self.imagePopover.delegate=self;
            self.imagePopover.popoverContentSize=CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    };
    
    return cell;
}

-(IBAction)addNewItem:(id)sender
{
    //NSInteger lastRow=[self.tableView numberOfRowsInSection:0];
    
    BNRItem *newItem=[[BNRItemStore sharedStore]createItem];
    
    /*NSInteger lastRow=[[[BNRItemStore sharedStore]allItems] indexOfObject:newItem];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];*/
    
    BNRDetailViewController *detailViewController=[[BNRDetailViewController alloc]initForNewItem:YES];
    detailViewController.item=newItem;
    
    detailViewController.dismissBlock=^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:detailViewController];
    navController.restorationIdentifier=NSStringFromClass([navController class]);
    navController.modalPresentationStyle=UIModalPresentationFormSheet;
    navController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:nil];
}

/*-(IBAction)toggleEditingMode:(id)sender
{
    //if you are currently in editing mode
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self setEditing:NO animated:YES];
    }
    else
    {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [self setEditing:YES animated:YES];
    }
}

-(UIView *)headerView
{
    //if headerView have not loaded yet...
    if (!_headerView) {
        //load HeaderView.xib
        [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}*/ 

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSArray *items=[[BNRItemStore sharedStore]allItems];
        BNRItem *item=items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BNRDetailViewController *detailViewController=[[BNRDetailViewController alloc]init];
    BNRDetailViewController *detailViewController=[[BNRDetailViewController alloc]initForNewItem:NO];
    
    NSArray *items=[[BNRItemStore sharedStore]allItems];
    BNRItem *selectedItem=items[indexPath.row];
    
    detailViewController.item=selectedItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.tableView reloadData];
    
    [self updateTableViewForDynamicTypeSize];
}

@end
