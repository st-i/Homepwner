//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by iStef on 18.12.16.
//  Copyright © 2016 Stefanov. All rights reserved.
//

//#import "BNRAssetTypeViewController.h"
#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "BNRItemsViewController.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation BNRDetailViewController

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    
    //save changes into item
    self.item.itemName=self.nameField.text;
    self.item.serialNumber=self.serialNumberField.text;
    self.item.valueInDollars=[self.valueField.text intValue];
    
    //have store save changes to disk
    [[BNRItemStore sharedStore]saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey=[coder decodeObjectForKey:@"item.itemKey"];
    
    for (BNRItem *item in [[BNRItemStore sharedStore]allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item=item;
            break;
        }
    }
    return [super decodeRestorableStateWithCoder:coder];
}

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew=NO;
    if ([identifierComponents count]==3) {
        isNew=YES;
    }
    return [[self alloc]initForNewItem:isNew];
}

/*- (IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    BNRAssetTypeViewController *atvc=[[BNRAssetTypeViewController alloc]init];
    
    
    [self.navigationController pushViewController:atvc animated:YES];
}*/

-(void)dealloc
{
    NSNotificationCenter *defaultCenter=[NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

-(void)updateFonts
{
    UIFont *font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font=font;
    self.serialNumberLabel.font=font;
    self.valueLabel.font=font;
    self.dateLabel.font=font;
    
    self.nameField.font=font;
    self.serialNumberField.font=font;
    self.valueField.font=font;
}

-(void)save:(id)sender
{
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(void)cancel:(id)sender
{
    [[BNRItemStore sharedStore]removeItem:self.item];
    
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];

}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    return nil;
}

-(instancetype)initForNewItem:(BOOL)isNew
{
    self=[super initWithNibName:nil bundle:nil];
    if (self) {
        self.restorationIdentifier=NSStringFromClass([self class]);
        self.restorationClass=[self class];
        if (isNew) {
            UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem=doneItem;
            
            UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem=cancelItem;
        }
        NSNotificationCenter *defaultCenter=[NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover!");
    self.imagePickerPopover=nil;
}

-(void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        return;
    }
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden=YES;
        self.cameraButton.enabled=NO;
    }else{
        self.imageView.hidden=NO;
        self.cameraButton.enabled=YES;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (IBAction)takePicture:(id)sender
{
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover=nil;
        return;
    }
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate=self;
    
    //place image picker on the screen
    //[self presentViewController:imagePicker animated:YES completion:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        self.imagePickerPopover=[[UIPopoverController alloc]initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate=self;
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io=[[UIApplication sharedApplication]statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BNRItem *item=self.item;
    
    self.nameField.text=item.itemName;
    self.serialNumberField.text=item.serialNumber;
    self.valueField.text=[NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter=nil;
    if (!dateFormatter) {
        dateFormatter=[[NSDateFormatter alloc]init];
        dateFormatter.dateStyle=NSDateFormatterMediumStyle;
        dateFormatter.timeStyle=NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text=[dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey=self.item.itemKey;
    
    //get the image for its image key from the image store
    UIImage *imageToDisplay=[[BNRImageStore sharedStore]imageForKey:imageKey];
    
    //use that image to put on the screen in the imageView
    self.imageView.image=imageToDisplay;
    
    /*NSString *typeLabel=[self.item.assetType valueForKey:@"label"];
    
    if (!typeLabel) {
        typeLabel=@"None";
    }
    
    self.assetTypeButton.title=[NSString stringWithFormat:@"Type: %@", typeLabel];*/
    
    BNRItemsViewController *bnrItems=[[BNRItemsViewController alloc]init];
    [bnrItems.tableView reloadData];
    
    [self updateFonts];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //clear first responder
    [self.view endEditing:YES];
    
    //save changes to item
    BNRItem *item=self.item;
    item.itemName=self.nameField.text;
    item.serialNumber=self.serialNumberField.text;
    item.valueInDollars=[self.valueField.text intValue];
}

-(void)setItem:(BNRItem *)item
{
    _item=item;
    //self.navigationItem.title=_item.itemName;
    self.navigationItem.title=[NSString stringWithFormat:NSLocalizedString(@"%@", @"Title of detail view"),  _item.itemName];
}

-(void)viewDidLoad
{
    [_nameField setDelegate:self];
    
    [super viewDidLoad];
    
    UIImageView *iv=[[UIImageView alloc]initWithImage:nil];
    
    //the contentMode of the image view in the XIB was Aspect Fit
    iv.contentMode=UIViewContentModeScaleAspectFit;
    
    //do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints=NO;
    
    //the image view was a subview of the view
    [self.view addSubview:iv];
    
    //the image view was pointed to by the imageView property
    self.imageView=iv;
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap=@{@"imageView": self.imageView,
                            @"dateLabel": self.dateLabel,
                            @"toolbar": self.toolbar};
    
    //imageView is 0 pts from superview at left and right edges
    NSArray *horizontalConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[imageView]-20-|" options:0 metrics:nil views:nameMap];
    
    //imageView is 8 pts from dateLabel at its top edge and 8 pts from toolbar at its bottom edge
    NSArray *verticalConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
    
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraints];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //get picked image from info dictionary
    UIImage *image=info[UIImagePickerControllerOriginalImage];

    [self.item setThumbnailFromImage:image];
    
    //store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore]setImage:image forKey:self.item.itemKey];
    
    //put that image onto the screen in our image view
    self.imageView.image=image;
    
    //take image picker off the screen - you must call this dismiss method
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover=nil;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}


@end
