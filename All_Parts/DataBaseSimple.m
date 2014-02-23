//
//  DataBaseSimple.m
//  XMLDemo01
//
//  Created by 毛志 on 14-1-16.
//  Copyright (c) 2014年 maozhi. All rights reserved.
//

//all_homepage

#import "DataBaseSimple.h"
static DataBaseSimple * simple = nil;

@implementation DataBaseSimple
{
    FMDatabase * _dataBase;
}

- (void)dealloc
{
    [_dataBase close];
}

+ (DataBaseSimple *)sharedDataBase
{
    if (simple == nil) {
        simple = [[DataBaseSimple alloc] init];
    }
    return simple;
}

- (id)init
{
    self = [super init];
    if (self) {
       // 创建数据库 创建表
        NSArray * arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * path = [arr objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"AllPartsDB.db"];
        NSLog(@"path is %@...",path);
        // 在指定的绝对路径下创建名为Test的数据库 (内存管理)
        _dataBase = [FMDatabase databaseWithPath:path];
        // 打开数据库
        if (![_dataBase open]) {
            NSLog(@"can not open dataBase!");
            return nil;
        }
        
//        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@ (Row integer PRIMARY KEY AUTOINCREMENT,Title text,Content text,Author text,IsRead text)",name];
        [_dataBase executeUpdate:@"CREATE TABLE if not exists all_homepage (id text PRIMARY KEY,title text,img_url text,author text,author_introduce text,content text,laud_count text,laud_flg text,markettime text,differ text,last_time text,shareUrl text, WxDesContent text,sWebLk text)"];
        [_dataBase executeUpdate:@"CREATE TABLE if not exists onepost(serial integer PRIMARY KEY AUTOINCREMENT,post text)"];
        [_dataBase executeUpdate:@"CREATE TABLE if not exists all_content (id text PRIMARY KEY,conttitle text,contauthor text,content text,contauthorintroduce text,sauth text,sgw text,swbn text,sweblk text,contmarkettime text,lastupdatedate text,praisenumber text)"];
        [_dataBase executeUpdate:@"CREATE TABLE if not exists all_question (id text PRIMARY KEY,questiontitle text,questioncontent text,answertitle text,answercontent text,markettime text,sweblk text,praisenumber text,lastupdatedate text)"];
    }
    return self;
}


- (NSDictionary*)getFromDataBaseFromTableName:(NSString*)name withMarketTime:(NSString *)time
{
    // 类似一个链表对象
    if ([name isEqualToString:@"all_homepage"]) {
         FMResultSet * rs = [_dataBase executeQuery:@"select * from all_homepage WHERE markettime=?",time];
         while ([rs next]) {
             NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
             [dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
             [dic setObject:[rs stringForColumn:@"title"] forKey:@"title"];
             [dic setObject:[rs stringForColumn:@"img_url"] forKey:@"img_url"];
             [dic setObject:[rs stringForColumn:@"author"] forKey:@"author"];
             [dic setObject:[rs stringForColumn:@"author_introduce"] forKey:@"author_introduce"];
             [dic setObject:[rs stringForColumn:@"content"] forKey:@"content"];
//             [dic setObject:[rs stringForColumn:@"laud_count"] forKey:@"laud_count"];
//             [dic setObject:[rs stringForColumn:@"laud_flg"] forKey:@"laud_flg"];
             [dic setObject:[rs stringForColumn:@"markettime"] forKey:@"markettime"];
//             [dic setObject:[rs stringForColumn:@"differ"] forKey:@"differ"];
//             [dic setObject:[rs stringForColumn:@"last_time"] forKey:@"last_time"];
//             [dic setObject:[rs stringForColumn:@"shareUrl"] forKey:@"shareUrl"];
//             [dic setObject:[rs stringForColumn:@"WxDesContent"] forKey:@"WxDesContent"];
             [dic setObject:[rs stringForColumn:@"sWebLk"] forKey:@"sWebLk"];
             return dic;
         }
     }
    else if ([name isEqualToString:@"all_content"]){
         FMResultSet * rs = [_dataBase executeQuery:@"select * from all_content WHERE contmarkettime=?",time];
         while ([rs next]) {
             NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
             [dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
             [dic setObject:[rs stringForColumn:@"conttitle"] forKey:@"conttitle"];
             [dic setObject:[rs stringForColumn:@"contauthor"] forKey:@"contauthor"];
             [dic setObject:[rs stringForColumn:@"content"] forKey:@"content"];
             [dic setObject:[rs stringForColumn:@"contauthorintroduce"] forKey:@"contauthorintroduce"];
             [dic setObject:[rs stringForColumn:@"sauth"] forKey:@"sauth"];
             [dic setObject:[rs stringForColumn:@"sgw"] forKey:@"sgw"];
             [dic setObject:[rs stringForColumn:@"swbn"] forKey:@"swbn"];
             [dic setObject:[rs stringForColumn:@"sweblk"] forKey:@"sweblk"];
             [dic setObject:[rs stringForColumn:@"contmarkettime"] forKey:@"contmarkettime"];
             [dic setObject:[rs stringForColumn:@"lastupdatedate"] forKey:@"lastupdatedate"];
             [dic setObject:[rs stringForColumn:@"praisenumber"] forKey:@"praisenumber"];
             return dic;
         }
     }
    else if ([name isEqualToString:@"all_question"]){
        FMResultSet * rs=[_dataBase executeQuery:@"select * from all_question WHERE markettime=?",time];
        while ([rs next]) {
            NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
            [dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
            [dic setObject:[rs stringForColumn:@"questiontitle"] forKey:@"questiontitle"];
            [dic setObject:[rs stringForColumn:@"questioncontent"] forKey:@"questioncontent"];
            [dic setObject:[rs stringForColumn:@"answertitle"] forKey:@"answertitle"];
            [dic setObject:[rs stringForColumn:@"answercontent"] forKey:@"answercontent"];
            [dic setObject:[rs stringForColumn:@"markettime"] forKey:@"markettime"];
            [dic setObject:[rs stringForColumn:@"sweblk"] forKey:@"sweblk"];
            [dic setObject:[rs stringForColumn:@"praisenumber"] forKey:@"praisenumber"];
            [dic setObject:[rs stringForColumn:@"lastupdatedate"] forKey:@"lastupdatedate"];
            return dic;
        }
    }
    return nil;
}
- (NSString *) getDate
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}
- (NSString *) getDateForYestoday:(double) day
{
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-day * 60*60*24]];
}
- (BOOL)insertDataForTableName:(NSString *)name with:(NSDictionary*)dic
{
    if ([name isEqualToString:@"all_homepage"]) {
        NSString* str=[dic objectForKey:@"strAuthor" ];
        NSRange range=[str rangeOfString:@"&"];
        NSString * author=[ str substringFromIndex:range.location+1];
        NSString *introduce=[str substringToIndex:range.location];
        return [_dataBase executeUpdate:@"INSERT INTO all_homepage (id,Title,img_url,author,author_introduce,content,markettime,sWebLK) VALUES (?,?,?,?,?,?,?,?)",
                [dic objectForKey:@"strHpId"],
                [dic objectForKey:@"strHpTitle"],
                [dic objectForKey:@"strOriginalImgUrl"],
                author,
                introduce,
                [dic objectForKey:@"strContent"],
                [dic objectForKey:@"strMarketTime"],
                [dic objectForKey:@"sWebLk"]];
    }
    else if ([name isEqualToString:@"all_content"]){
        return [_dataBase executeUpdate:@"INSERT INTO all_content (id,conttitle,contauthor,content,contauthorintroduce,sauth,sgw,swbn,sweblk,contmarkettime,lastupdatedate,praisenumber) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                [dic objectForKey:@"strContentId"],
                [dic objectForKey:@"strContTitle"],
                [dic objectForKey:@"strContAuthor"],
                [dic objectForKey:@"strContent"],
                [dic objectForKey:@"strContAuthorIntroduce"],
                [dic objectForKey:@"sAuth"],
                [dic objectForKey:@"sGW"],
                [dic objectForKey:@"sWbN"],
                [dic objectForKey:@"sWebLk"],
                [dic objectForKey:@"strContMarketTime"],
                [dic objectForKey:@"strLastUpdateDate"],
                [dic objectForKey:@"strPraiseNumber"]];
    }
    else if ([name isEqualToString:@"all_question"]){
        return [_dataBase executeUpdate:@"INSERT IN all_question (id,questiontitle,questioncontent,answertitle,answercontent,markettime,sweblk,praisenumber,lastupdatedate)",
                [dic objectForKey:@"strQuestionId"],
                [dic objectForKey:@"strQuestionTitle"],
                [dic objectForKey:@"strQuestionContent"],
                [dic objectForKey:@"strAnswerTitle"],
                [dic objectForKey:@"strQuestionId"],
                [dic objectForKey:@"strAnswerContent"],
                [dic objectForKey:@"strQuestionMarketTime"],
                [dic objectForKey:@"sWebLk"],
                [dic objectForKey:@"strPraiseNumber"],
                [dic objectForKey:@"strLastUpdateDate"]];
    }
    return NO;
}
-(BOOL) insertOnePost:(NSString*) str
{
    [_dataBase executeUpdate:@"DELETE FROM onepost"];
    return [_dataBase executeUpdate:@"INSERT INTO onepost (post) VALUES (?)",str];
}
-(NSString *) getOnePost
{
    FMResultSet * rs=[_dataBase executeQuery:@"SELECT * FROM onepost"];
    while ([rs next]) {
        return [rs stringForColumn:@"post"];
    }
    return nil;
//    return @"[{\"result\":\"ERROR\"}]";
}

//{CREATE TABLE if not exists all_homepage (id text,title text,img_url text,author text,author_introduce text,content text,laud_count text,laud_flg text,makettime text,differ text,last_time text,shareUrl text, WxDesContent text,sWebLk text)
//    "sWebLk": "http://wufazhuce.com/one/vol.501",
//    "strAuthor": "冰雕匠&摄影/安一然",
//    "strContent": "有些事情我不看透，不是我太笨，只是我太善良。from《樱桃小丸子》",
//    "strDayDiffer": "",
//    "strHpId": "520",
//    "strHpTitle": "VOL.501",
//    "strLastUpdateDate": "2014-02-19 21:43:55",
//    "strMarketTime": "2014-02-20",
//    "strOriginalImgUrl": "http://pic.yupoo.com/hanapp/Dy83BPCX/tcK8O.jpg",
//    "strPn": "6",
//    "strThumbnailUrl": "http://pic.yupoo.com/hanapp/Dy83BPCX/tcK8O.jpg"
//}

//- (BOOL)insertData:(NewsModel *)model andKey:(NSInteger)index
//{
//    return [_dataBase executeUpdate:@"INSERT INTO News (Row,Title,Content,Author,IsRead) VALUES (?,?,?,?,?)",[NSNumber numberWithInt:index],model.title,model.description,model.author,model.isRead];
//}
//- (BOOL)deleteDataWithKey:(NSInteger)index
//{
//    return [_dataBase executeUpdate:@"DELETE FROM News WHERE Row=?",[NSNumber numberWithInt:index]];
//}
//- (BOOL)updataDataWithkey:(NSInteger)index andModifyData:(NewsModel *)model
//{
//    return [_dataBase executeUpdate:@"UPDATE News SET Title=?, Content=?,Author=?,IsRead=? WHERE Row=?",model.title,model.description,model.author
//            ,model.isRead,[NSNumber numberWithInt:index]];
//}
//- (NSMutableArray *)selectFromDataBase:(NSString *)name
//{
//    FMResultSet * rs = [_dataBase executeQuery:@"select * from News"];
//    NSMutableArray * arr = [NSMutableArray array];
//    while ([rs next]) {
//        NewsModel * model = [[[NewsModel alloc] init] autorelease];
//        model.title = [rs stringForColumn:@"Title"];
//        model.description = [rs stringForColumn:@"Content"];
//        model.author = [rs stringForColumn:@"Author"];
//        model.isRead = [rs stringForColumn:@"IsRead"];
//        [arr addObject:model];
//    }
//    return arr;
//}
//- (BOOL)cleanTable:(NSString *)name
//{
//    return [_dataBase executeUpdate:@"DELETE FROM News"];
//}
//- (BOOL)deleteTable:(NSString *)name
//{
//    return [_dataBase executeUpdate:@"DROP TABLE News"];
//}

@end
