/*
 *  RequestStrings.c
 *  BlogEditor
 *
 *  Created by Antonio "Willy" Malara on 28/08/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#import "RequestStrings.h"

NSString * getRecentPosts = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
<methodCall>\
<methodName>metaWeblog.getRecentPosts</methodName>\
<params>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value><int>10</int></value>\
</param>\
</params>\
</methodCall>\
";

NSString * pageTemplate = @"<html><style>body { font-family: Helvetica; }</style><body>%@</body></html>";

NSString * newPost = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
<methodCall>\
<methodName>metaWeblog.newPost</methodName>\
<params>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value>\
<struct>\
<member>\
<name>description</name>\
<value><string>%@</string></value>\
</member>\
<member>\
<name>title</name>\
<value><string>%@</string></value>\
</member>\
</struct>\
</value>\
</param>\
<param>\
<value><boolean>1</boolean></value>\
</param>\
</params>\
</methodCall>";

NSString * getCategories = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
<methodCall>\
<methodName>metaWeblog.getCategories</methodName>\
<params>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value><string>%@</string></value>\
</param>\
<param>\
<value><string>%@</string></value>\
</param>\
</params>\
</methodCall>\
";
