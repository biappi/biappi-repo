//
//  BlogEditorAppDelegate.h
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 17/08/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AppDelegate ((BlogEditorAppDelegate *)[[UIApplication sharedApplication] delegate])

@interface BlogEditorAppDelegate : NSObject <UIApplicationDelegate>
{
	NSMutableArray * blogs;
	NSMutableData * receiveddata;
	NSMutableDictionary * blogValues;
	NSMutableDictionary * blogCategories;
	
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
	IBOutlet UIToolbar *toolbar;
}

@property(readonly, nonatomic) NSMutableArray * blogs;
@property(nonatomic, retain) UIWindow * window;
@property(nonatomic, retain) UINavigationController * navigationController;

- (void)addBlogAtURL:(NSString *)endpoint withID:(NSString *)anID name:(NSString *)name username:(NSString *)anUsername andPassword:(NSString *)aPass;
- (void)removeBlogWithIndex:(int)blogIndex;
- (void)updateBlogWithIndex:(int)blogIndex;
- (void)createPostForBlogWithIndex:(int)blogIndex title:(NSString *)aTitle description:(NSString *)theDescription;
- (void)modifyPostWithIndex:(int)postIndex forBlogWithIndex:(int)blogIndex title:(NSString *)aTitle description:(NSString *)theDescription;
- (void)setValue:(id)value forBlogWithIndex:(int)idx;
- (id)getValueForBlogWithIndex:(int)idx;
- (NSArray *)categoriesArrayForBlogIndex:(int)idx;

@end

