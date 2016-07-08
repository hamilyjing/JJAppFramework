//
//  JJEncryptUtil.m
//  JJ_iOS_Service
//
//  Created by JJ on 2/25/16.
//  Copyright © 2016 PingAn. All rights reserved.
//

#import "JJEncryptUtil.h"

#import "CommonCrypto/CommonCryptor.h"

@implementation JJEncryptUtil

+ (NSData *)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSString *)iv source:(NSData *)source
{
    //length
    size_t plainTextBufferSize = [source length];
    const void *vplainText = (const void *)[source bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [key UTF8String];
    //偏移量
    const void *vinitVec = (const void *) [iv UTF8String];
    //配置CCCrypt
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES, //3DES
                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                       vkey,  //key
                       kCCKeySize3DES,
                       vinitVec,   //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (kCCSuccess != ccStatus)
    {
        return nil;
    }
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    //NSString *result = [GTMBase64 stringByEncodingData:myData];
    return myData;
}

+ (NSData *)decryptedWith3DESUsingKey:(NSString *)key andIV:(NSString *)iv source:(NSData *)source
{
    //NSData *encryptData = [GTMBase64 decodeData:[encryptStr dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [source length];
    const void *vplainText = [source bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [iv UTF8String];
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding|kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (kCCSuccess != ccStatus)
    {
        return nil;
    }
    
    NSData *data = [NSData dataWithBytes:(const void *)bufferPtr
                                  length:(NSUInteger)movedBytes];
    return data;
}

@end
