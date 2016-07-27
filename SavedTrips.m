//
//  SavedTrips.m
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "SavedTrips.h"
#import "FMDatabase.h"
#import "prefix.h"

#define COLUMN_NAME_SAVED_TRIP_ID @"savedTripId"
#define COLUMN_NAME_STOP_FROM @"stop_from"
#define COLUMN_NAME_STOP_TO @"stop_to"
#define COLUMN_NAME_STOP_FROM_NAME @"stop_from_name"
#define COLUMN_NAME_STOP_TO_NAME @"stop_to_name"
#define COLUMN_NAME_ROUTE_ID @"route_id"
#define COLUMN_NAME_ROUTE_NAME @"route_name"

@implementation SavedTrips
+(NSMutableArray *) getSavedTrips{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [SavedTrips checkTableCreatedInDb:db];
    NSMutableArray * rtn = [[NSMutableArray alloc] init];
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@",TABLE_NAME]];
    
    while ([rs next]) {
        SavedTrips * savedTrips = [[SavedTrips alloc]init];
        savedTrips.saved_trip_id=[rs stringForColumn:COLUMN_NAME_SAVED_TRIP_ID];
        savedTrips.stop_from = [rs stringForColumn:COLUMN_NAME_STOP_FROM];
        savedTrips.stop_to = [ rs stringForColumn:COLUMN_NAME_STOP_TO];
        savedTrips.stop_from_name = [rs stringForColumn:COLUMN_NAME_STOP_FROM_NAME];
        savedTrips.stop_to_name = [rs stringForColumn:COLUMN_NAME_STOP_TO_NAME];
        savedTrips.route_id = [rs stringForColumn:COLUMN_NAME_ROUTE_ID];
        savedTrips.route_name = [ rs stringForColumn:COLUMN_NAME_ROUTE_NAME];
        [rtn addObject:savedTrips];
    }
    [rs close];
    [db close];
    return rtn;
}
+(BOOL) saveTrip:(SavedTrips*)trip{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [SavedTrips checkTableCreatedInDb:db];
    NSString *sqlStr ;
    if (trip.saved_trip_id==nil){
        sqlStr=[NSString stringWithFormat:@"INSERT INTO  %@(%@, %@,%@,%@,%@,%@) VALUES (?, ?,?,?,?,?)",TABLE_NAME,COLUMN_NAME_STOP_FROM,COLUMN_NAME_STOP_TO,COLUMN_NAME_STOP_FROM_NAME,COLUMN_NAME_STOP_TO_NAME,COLUMN_NAME_ROUTE_ID,COLUMN_NAME_ROUTE_NAME];
    }else{
        sqlStr=[NSString stringWithFormat:@"Update  %@ set %@=?, %@=?,%@=?,%@=?,%@=?,%@=? where %@=?",TABLE_NAME,COLUMN_NAME_STOP_FROM,COLUMN_NAME_STOP_TO,COLUMN_NAME_STOP_FROM_NAME,COLUMN_NAME_STOP_TO_NAME,COLUMN_NAME_ROUTE_ID,COLUMN_NAME_ROUTE_NAME,COLUMN_NAME_SAVED_TRIP_ID];
    }
    
    
    BOOL worked = [db executeUpdate:sqlStr,trip.stop_from,trip.stop_to,trip.stop_from_name,trip.stop_to_name,trip.route_id,trip.route_name];
    [db close];
    
    
    return worked;
    
}

+(BOOL)deleteTrip:(SavedTrips*)trip{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    NSString *sqlStr =[NSString stringWithFormat:@"delete  from %@ where %@ =?",TABLE_NAME,COLUMN_NAME_SAVED_TRIP_ID];
    BOOL worked = [db executeUpdate:sqlStr,trip.saved_trip_id];
    [db close];
    return worked;
}


+(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr=[NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('%@' integer primary key autoincrement , '%@' VARCHAR, '%@' VARCHAR, '%@' VARCHAR,'%@' VARCHAR, '%@' varchar,'%@' varchar)",TABLE_NAME,COLUMN_NAME_SAVED_TRIP_ID,COLUMN_NAME_STOP_FROM,COLUMN_NAME_STOP_TO,COLUMN_NAME_STOP_FROM_NAME,COLUMN_NAME_STOP_TO_NAME,COLUMN_NAME_ROUTE_ID,COLUMN_NAME_ROUTE_NAME];
    
    BOOL worked = [db executeUpdate:createStr];
    //FMDBQuickCheck(worked);
    return worked;
    
}
@end
