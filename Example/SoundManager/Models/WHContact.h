//
//  WHContact.h
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHContact : NSObject

@property (nonatomic) NSURL * imageUrl;
@property (nonatomic) NSString * homePage;
@property (nonatomic) NSArray * emails;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString *position;
@property (nonatomic) NSArray * addresses;
@property (nonatomic) NSDictionary * companyDetails;
@property (nonatomic) long age;
@property (nonatomic) NSArray * phoneNumbers;

@end
