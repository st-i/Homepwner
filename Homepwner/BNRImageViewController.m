//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by iStef on 07.01.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //we must cast the view to UIImageView so the compiler knows it is okay to send it setImage:
    UIImageView *imageView=(UIImageView *)self.view;
    imageView.image=self.image;
}

-(void)loadView
{
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.view=imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
