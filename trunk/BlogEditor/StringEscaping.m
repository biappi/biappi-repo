//
//  StringEscaping.m
//  BlogEditor
//
//  Created by Antonio "Willy" Malara on 04/09/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

// Blindly copied from http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/Foundation/GTMNSString+XML.m?r=24

#import "StringEscaping.h"

enum {
	kGTMXMLCharModeEncodeQUOT  = 0,
	kGTMXMLCharModeEncodeAMP   = 1,
	kGTMXMLCharModeEncodeAPOS  = 2,
	kGTMXMLCharModeEncodeLT    = 3,
	kGTMXMLCharModeEncodeGT    = 4,
	kGTMXMLCharModeValid       = 99,
	kGTMXMLCharModeInvalid     = 100,
};
typedef NSUInteger GTMXMLCharMode;

static NSString *gXMLEntityList[] = {
// this must match the above order
@"&quot;",
@"&amp;",
@"&apos;",
@"&lt;",
@"&gt;",
};


GTMXMLCharMode XMLModeForUnichar(UniChar c) {
	
	// Per XML spec Section 2.2 Characters
	//   ( http://www.w3.org/TR/REC-xml/#charsets )
	//
	//   Char    ::=       #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] |
	//                      [#x10000-#x10FFFF]
	
	if (c <= 0xd7ff)  {
		if (c >= 0x20) {
			switch (c) {
				case 34:
					return kGTMXMLCharModeEncodeQUOT;
				case 38:
					return kGTMXMLCharModeEncodeAMP;
				case 39:
					return kGTMXMLCharModeEncodeAPOS;
				case 60:
					return kGTMXMLCharModeEncodeLT;
				case 62:
					return kGTMXMLCharModeEncodeGT;
				default:
					return kGTMXMLCharModeValid;
			}
		} else {
			if (c == '\n')
				return kGTMXMLCharModeValid;
			if (c == '\r')
				return kGTMXMLCharModeValid;
			if (c == '\t')
				return kGTMXMLCharModeValid;
			return kGTMXMLCharModeInvalid;
		}
	}
	
	if (c < 0xE000)
		return kGTMXMLCharModeInvalid;
	
	if (c <= 0xFFFD)
		return kGTMXMLCharModeValid;
	
	// UniChar can't have the following values
	// if (c < 0x10000)
	//   return kGTMXMLCharModeInvalid;
	// if (c <= 0x10FFFF)
	//   return kGTMXMLCharModeValid;
	
	return kGTMXMLCharModeInvalid;
} // XMLModeForUnichar

NSString *AutoreleasedCloneForXML(NSString *src, BOOL escaping) {
	//
	// NOTE:
	// We don't use CFXMLCreateStringByEscapingEntities because it's busted in
	// 10.3 (http://lists.apple.com/archives/Cocoa-dev/2004/Nov/msg00059.html) and
	// it doesn't do anything about the chars that are actually invalid per the
	// xml spec.
	//
	
	// we can't use the CF call here because it leaves the invalid chars
	// in the string.
	NSUInteger length = [src length];
	if (!length) {
		return src;
	}
	
	NSMutableString *finalString = [NSMutableString string];
	
	// this block is common between GTMNSString+HTML and GTMNSString+XML but
	// it's so short that it isn't really worth trying to share.
	const UniChar *buffer = CFStringGetCharactersPtr((CFStringRef)src);
	if (!buffer) {
		size_t memsize = length * sizeof(UniChar);
		
		// nope, alloc buffer and fetch the chars ourselves
		buffer = malloc(memsize);
		if (!buffer) {
			return nil;
		}
		[src getCharacters:(void*)buffer];
		[NSData dataWithBytesNoCopy:(void*)buffer length:memsize];
	}
	
	const UniChar *goodRun = buffer;
	NSUInteger goodRunLength = 0;
	
	for (NSUInteger i = 0; i < length; ++i) {
		
		GTMXMLCharMode cMode = XMLModeForUnichar(buffer[i]);
		
		// valid chars go as is, and if we aren't doing entities, then
		// everything goes as is.
		if ((cMode == kGTMXMLCharModeValid) ||
			(!escaping && (cMode != kGTMXMLCharModeInvalid))) {
			// goes as is
			goodRunLength += 1;
		} else {
			// it's something we have to encode or something invalid
			
			// start by adding what we already collected (if anything)
			if (goodRunLength) {
				CFStringAppendCharacters((CFMutableStringRef)finalString, 
										 goodRun, 
										 goodRunLength);
				goodRunLength = 0;
			}
			
			// if it wasn't invalid, add the encoded version
			if (cMode != kGTMXMLCharModeInvalid) {
				// add this encoded
				[finalString appendString:gXMLEntityList[cMode]];
			}
			
			// update goodRun to point to the next UniChar
			goodRun = buffer + i + 1;
		}
	}
	
	// anything left to add?
	if (goodRunLength) {
		CFStringAppendCharacters((CFMutableStringRef)finalString, 
								 goodRun, 
								 goodRunLength);
	}
	return finalString;
} // AutoreleasedCloneForXML
