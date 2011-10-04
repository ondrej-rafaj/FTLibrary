//
//  FTShareDataObjects.m
//  IKEA_settings
//
//  Created by Francesco on 04/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FTShareDataObjects.h"

#pragma mark Twitter Data Structure

@implementation FTShareTwitterData 

@synthesize message = _message;

- (BOOL)isRequestValid {
    return (self.message && [self.message length] > 0);
}

- (void)dealloc {
    
    [_message release], _message = nil;
    [super dealloc];
}

@end


#pragma mark Facebook Data Structure

@implementation FTShareFacebookData

@synthesize message = _message;
@synthesize link = _link;
@synthesize caption = _caption;
@synthesize picture = _picture;
@synthesize description = _description;
@synthesize uploadImage = _uploadImage;



- (BOOL)isRequestValid {
    return (self.message && [self.message length] > 0);
}

- (NSMutableDictionary *)dictionaryFromParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.message) [dict setObject:self.message forKey:@"message"];
    if (self.link) [dict setObject:self.link forKey:@"link"];
    if (self.caption) [dict setObject:self.caption forKey:@"caption"];
    if (self.picture) [dict setObject:self.picture forKey:@"picture"];
    if (self.description) [dict setObject:self.description forKey:@"description"];
    if (self.uploadImage && !CGSizeEqualToSize(self.uploadImage.size, CGSizeZero)) [dict setObject:self.uploadImage forKey:@"uploadImage"];
    
    return dict;
}

- (void)dealloc {
    
    [_message release], _message = nil;
    [_link release], _link = nil;
    [_caption release], _caption = nil;
    [_picture release], _picture = nil;
    [_description release], _description = nil;
    [_uploadImage release], _uploadImage = nil;
    [super dealloc];
}

@end


#pragma mark Mail Data Structure

@implementation FTShareMailData

@synthesize subject = _subject;
@synthesize plainBody = _plainBody;
@synthesize htmlBody = _htmlBody;
@synthesize attachments = _attachments;

- (id)init {
    self = [super init];
    if (self) {
        _attachments = [NSMutableArray array];
    }
    return self;
}


- (BOOL)isRequestValid {
    return YES;
}

- (void)addAttachmentWithObject:(NSData *)data type:(NSString *)type andName:(NSString *)name {
    NSDictionary *dict = [NSDictionary 
                          dictionaryWithObjects:[NSArray arrayWithObjects:data, type, name, nil] 
                          forKeys:[NSArray arrayWithObjects:@"data", @"type", @"name", nil] ];
    [_attachments addObject:dict];
}

- (void)dealloc {
    
    [_subject release], _subject = nil;
    [_plainBody release], _plainBody = nil;
    [_htmlBody release], _htmlBody = nil;
    [_attachments release], _attachments = nil;
    [super dealloc];
}

@end