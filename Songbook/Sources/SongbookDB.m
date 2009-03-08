//
//  SongbookDB.m
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SongbookDB.h"
#import <sqlite3.h>

inline static sqlite3 * db()
{
	static sqlite3 * db = nil;
	
	if (db == nil)
	{
		NSArray  * paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString * docs   = [paths objectAtIndex:0];
		
		NSInteger  result;

		result = sqlite3_open([[docs stringByAppendingPathComponent:@"songbook.db"] UTF8String], &db);
		NSCAssert(result == SQLITE_OK, @"Failed to open the db connection");
		
		result = sqlite3_exec(db,
							  "CREATE TABLE IF NOT EXISTS songbook ("
							  "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
							  "artist, title, chordtext)",
							  nil,
							  nil,
							  nil);
		NSCAssert(result == SQLITE_OK, @"Failed to create sbook");		
	}
	
	return db;
}

@implementation SongbookDB

+ (SongbookDB *)db;
{
	static SongbookDB * sharedDB = nil;

	if (sharedDB == nil)
		sharedDB = [[SongbookDB alloc] init];
	
	return sharedDB;
}

#pragma mark Artists

- (NSArray *)artists;
{
	static sqlite3_stmt * query   = nil;
	NSMutableArray      * artists = [NSMutableArray array];
	NSInteger             result;
	
	if (query == nil)
	{
		result = sqlite3_prepare(db(),
								 "SELECT DISTINCT artist FROM songbook ORDER BY artist",
								 -1,
								 &query,
								 nil);
		NSAssert(result == SQLITE_OK, @"Failed to prepare the count artist statement");
	}
	
	while ((result = sqlite3_step(query)) == SQLITE_ROW)
	{
		[artists addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(query, 0)]];
	}
	
	NSAssert(result == SQLITE_DONE, @"Faliure in the get artist statement");
	
	result = sqlite3_reset(query);
	NSAssert(result == SQLITE_OK, @"Failed to reset the get artist statement");

	return [NSArray arrayWithArray:artists];
}

#pragma mark Songs

- (void)insertSongWithArtist:(NSString *)artist title:(NSString *)title chords:(NSString *)chords;
{
	static sqlite3_stmt * insertSong = nil;
	NSInteger result;
	
	if (insertSong == nil)
	{
		result = sqlite3_prepare(db(),
								 "INSERT INTO songbook "
								 "(artist, title, chordtext) "
								 "VALUES (?, ?, ?)",
								 -1,
								 &insertSong,
								 nil);
		
		NSAssert(result == SQLITE_OK, @"Failed to prepare the insert song statement");
	}
	
	result = sqlite3_bind_text(insertSong, 1, [artist UTF8String], -1, SQLITE_STATIC);
	NSAssert (result == SQLITE_OK, @"Failed to bind the artist data");
	
	result = sqlite3_bind_text(insertSong, 2, [title  UTF8String], -1, SQLITE_STATIC);
	NSAssert (result == SQLITE_OK, @"Failed to bind the title data");
	
	result = sqlite3_bind_text(insertSong, 3, [chords UTF8String], -1, SQLITE_STATIC);
	NSAssert (result == SQLITE_OK, @"Failed to bind the text data");
	
	result = sqlite3_step(insertSong); 
	NSAssert(result == SQLITE_DONE, @"Failed to step the insert song statement");
	
	result = sqlite3_reset(insertSong);
	NSAssert(result == SQLITE_OK, @"Failed to reset the insert song statement");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"db updated" object:nil];
}

- (void)updateSongID:(NSInteger)songID withArtist:(NSString *)artist title:(NSString *)title chords:(NSString *)chords;
{
	static sqlite3_stmt * query = nil;
	NSInteger result;
	
	if (query == nil)
	{
		result = sqlite3_prepare(db(),
								 "UPDATE songbook "
								 "SET artist = ?, title = ?, chordtext = ? "
								 "WHERE id = ?",
								 -1,
								 &query,
								 nil);
		
		NSAssert(result == SQLITE_OK, @"Failed to prepare the update song statement");
	}
	
	result = sqlite3_bind_text(query, 1, [artist UTF8String], -1, SQLITE_STATIC);
	NSAssert (result == SQLITE_OK, @"Failed to bind the artist data");
	
	result = sqlite3_bind_text(query, 2, [title  UTF8String], -1, SQLITE_STATIC);
	NSAssert (result == SQLITE_OK, @"Failed to bind the title data");
	
	result = sqlite3_bind_text(query, 3, [chords UTF8String], -1, SQLITE_STATIC);
	NSAssert (result == SQLITE_OK, @"Failed to bind the text data");
	
	result = sqlite3_bind_int (query, 4, songID);
	NSAssert (result == SQLITE_OK, @"Failed to bind the song id");
	
	result = sqlite3_step(query); 
	NSAssert(result == SQLITE_DONE, @"Failed to step the update song statement");
	
	result = sqlite3_reset(query);
	NSAssert(result == SQLITE_OK, @"Failed to reset the update song statement");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"db updated" object:nil];
}

- (NSArray *)songsForArtist:(NSString *)artist;
{
	static sqlite3_stmt * query = nil;
	NSMutableArray      * songs = [NSMutableArray array];
	NSInteger             result;
	
	if (query == nil)
	{
		result = sqlite3_prepare(db(),
								 "SELECT id, title, artist FROM songbook WHERE artist=? ORDER BY title",
								 -1,
								 &query,
								 nil);
		NSAssert(result == SQLITE_OK, @"Failed to prepare the get songs statement");
	}
	
	result = sqlite3_bind_text(query, 1, [artist UTF8String], -1, SQLITE_STATIC);
	NSAssert (result == SQLITE_OK, @"Failed to bind the get songs data");
	
	while ((result = sqlite3_step(query)) == SQLITE_ROW)
	{
		[songs addObject:
			[NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:sqlite3_column_int(query, 0)],
				@"id",
				[NSString stringWithUTF8String:(char *)sqlite3_column_text(query, 1)],
				@"title",
				// [NSString stringWithFormat:@"%s", sqlite3_column_text(query, 2)],
				// @"artist",
				nil
			 ]
		 ];
	}
	
	NSAssert(result == SQLITE_DONE, @"Faliure in the get songs statement");
	
	result = sqlite3_reset(query);
	NSAssert(result == SQLITE_OK, @"Failed to reset the get songs statement");
	
	return [NSArray arrayWithArray:songs];
}

- (NSArray *)allSongs;
{
	static sqlite3_stmt * query = nil;
	NSMutableArray      * songs = [NSMutableArray array];
	NSInteger             result;
	
	if (query == nil)
	{
		result = sqlite3_prepare(db(),
								 "SELECT id, title, artist FROM songbook ORDER BY title",
								 -1,
								 &query,
								 nil);
		NSAssert(result == SQLITE_OK, @"Failed to prepare the get all songs statement");
	}
	
	while ((result = sqlite3_step(query)) == SQLITE_ROW)
	{
		[songs addObject:
		 [NSDictionary dictionaryWithObjectsAndKeys:
		  [NSNumber numberWithInt:sqlite3_column_int(query, 0)],
		  @"id",
		  [NSString stringWithUTF8String:(char *)sqlite3_column_text(query, 1)],
		  @"title",
		  [NSString stringWithUTF8String:(char *)sqlite3_column_text(query, 2)],
		  @"artist",
		  nil
		  ]
		 ];
	}
	
	NSAssert(result == SQLITE_DONE, @"Faliure in the get all songs statement");
	
	result = sqlite3_reset(query);
	NSAssert(result == SQLITE_OK, @"Failed to reset the get all songs statement");
	
	return [NSArray arrayWithArray:songs];
}

- (NSDictionary *)songWithID:(NSInteger)songID;
{
	static sqlite3_stmt * query = nil;
	NSDictionary * song = nil;
	NSInteger      result;
	
	if (query == nil)
	{
		result = sqlite3_prepare(db(),
								 "SELECT id, title, artist, chordtext FROM songbook WHERE id=?",
								 -1,
								 &query,
								 nil);
		NSAssert(result == SQLITE_OK, @"Failed to prepare the get songs statement");
	}
	
	result = sqlite3_bind_int(query, 1, songID);
	NSAssert (result == SQLITE_OK, @"Failed to bind the get songs data");
	
	while ((result = sqlite3_step(query)) == SQLITE_ROW)
	{
		song =
			[NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:sqlite3_column_int(query, 0)],
				@"id",
				[NSString stringWithUTF8String:(char *)sqlite3_column_text(query, 1)],
				@"title",
				[NSString stringWithUTF8String:(char *)sqlite3_column_text(query, 2)],
				@"artist",
				[NSString stringWithUTF8String:(char *)sqlite3_column_text(query, 3)],
				@"chords",
				nil
			 ];
	}
	
	NSAssert(result == SQLITE_DONE, @"Faliure in the get songs statement");
	
	result = sqlite3_reset(query);
	NSAssert(result == SQLITE_OK, @"Failed to reset the get songs statement");
	
	return song;
}

- (void)deleteSongWithID:(NSInteger)songID;
{
	static sqlite3_stmt * query = nil;
	NSInteger result;
	
	if (query == nil)
	{
		result = sqlite3_prepare(db(),
								 "DELETE FROM songbook "
								 "WHERE id = ?",
								 -1,
								 &query,
								 nil);
		
		NSAssert(result == SQLITE_OK, @"Failed to prepare the delete song statement");
	}
	
	result = sqlite3_bind_int (query, 1, songID);
	NSAssert (result == SQLITE_OK, @"Failed to bind the song id");
	
	result = sqlite3_step(query); 
	NSAssert(result == SQLITE_DONE, @"Failed to step the delete song statement");
	
	result = sqlite3_reset(query);
	NSAssert(result == SQLITE_OK, @"Failed to reset the delete song statement");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"db updated" object:nil];
}

@end
