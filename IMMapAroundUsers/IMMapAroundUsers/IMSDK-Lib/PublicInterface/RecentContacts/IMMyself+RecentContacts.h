//
//  IMMyself+RecentContacts.h
//  IMSDK
//
//  Created by lyc on 14-10-4.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMMyself.h"
#import "IMUserChatMessage.h"

/**
 @header IMMyself+RecentContacts
 @abstract IMMyself最近联系人类别，为IMMyself提供获取和移除最近联系人功能。
 */
@interface IMMyself (RecentContacts)

/**
 @method
 @brief 获取最近联系人
 @return 最近联系人用户名的集合
 */
- (NSArray *)recentContacts;

/**
 @method
 @brief 从最近联系人中移除某个用户（本地移除）
 @param customUserID 移除对象的用户名
 */
- (BOOL)removeRecentContact:(NSString *)customUserID;

- (NSInteger)chatMessageCountWithUser:(NSString *)customUserID;

- (IMUserChatMessage *)chatMessageWithUser:(NSString *)customUserID index:(NSInteger)index;

- (NSInteger)unreadChatMessageCount;

- (NSInteger)unreadChatMessageCountWithUser:(NSString *)customUserID;

- (BOOL)clearUnreadChatMessage;

- (BOOL)clearUnreadChatMessageWithUser:(NSString *)customUserID;

- (NSString *)lastErrorForRecentContacts;

@end
