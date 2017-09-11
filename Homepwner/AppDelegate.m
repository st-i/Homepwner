//
//  AppDelegate.m
//  Homepwner
//
//  Created by iStef on 28.11.16.
//  Copyright © 2016 Stefanov. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIViewController *vc=[[UINavigationController alloc]init];
    
    vc.restorationIdentifier=[identifierComponents lastObject];
    
    if ([identifierComponents count]==1) {
        self.window.rootViewController=vc;
    }
    return vc;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.window.backgroundColor=[UIColor whiteColor];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //if state restoration did not occur, set up the view controller hierarchy
    if (!self.window.rootViewController) {
        BNRItemsViewController *itemsViewController=[[BNRItemsViewController alloc]init];
        
    //Create an instance of a UINavigationController
    //its stack contains only itemsViewController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:itemsViewController];
    
    //give the navigation controller a restoration identifier that is the same name as the class
        navController.restorationIdentifier=NSStringFromClass([navController class]);
    
    //Place navigation's controller view in the window hierarchy
        self.window.rootViewController=navController;
    }
    //Place BNRItemsViewController table view in the window hierarchy
    //self.window.rootViewController=itemsViewController;
    //self.window.backgroundColor=[UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success=[[BNRItemStore sharedStore]saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems!");
    }else{
        NSLog(@"Could not save any of the BNRItems!");
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
