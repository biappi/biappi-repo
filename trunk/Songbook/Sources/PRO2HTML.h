//
//  PRO2HTML.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 24/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * parsePROToHTML(NSString * pro);

void zapTitleAndSubtitle(NSMutableString * pro);
NSString * parseSubTitle(NSString * html);
NSString * parseTitle(NSString * html);
