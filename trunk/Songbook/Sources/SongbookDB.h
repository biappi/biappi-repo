//
//  SongbookDB.h
//  Songbook
//
//  Created by Antonio "Willy" Malara on 21/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongbookDB : NSObject
{
}

+ (SongbookDB *)db;

- (NSArray *)artists;
- (void)insertSongWithArtist:(NSString *)artist title:(NSString *)title chords:(NSString *)chords;
- (void)updateSongID:(NSInteger)songID withArtist:(NSString *)artist title:(NSString *)title chords:(NSString *)chords;
- (NSArray *)songsForArtist:(NSString *)artist;
- (NSArray *)allSongs;
- (NSDictionary *)songWithID:(NSInteger)songID;
- (void)deleteSongWithID:(NSInteger)songID;

@end
