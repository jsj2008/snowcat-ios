//
//  mof_protocol.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-8.
//  Copyright (c) 2014 Moky. All rights reserved.
//

#ifndef __mof_protocol__
#define __mof_protocol__

/**
 *  Size and alignment of integer data types in OS X and iOS:
 *
 *    /============+============+=================+===========+================\
 *    | Data type  | ILP32 size | ILP32 alignment | LP64 size | LP64 alignment |
 *    +============+============+=================+===========+================+
 *    | char       | 1 byte     | 1 byte          | 1 byte    | 1 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | BOOL, bool | 1 byte     | 1 byte          | 1 byte    | 1 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | short      | 2 byte     | 2 byte          | 2 byte    | 2 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | int        | 4 byte     | 4 byte          | 4 byte    | 4 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | long       | 4 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | long long  | 8 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | pointer    | 4 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | size_t     | 4 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | time_t     | 4 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | NSInteger  | 4 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | CFIndex    | 4 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | fpos_t     | 8 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    +------------+------------+-----------------+-----------+----------------+
 *    | off_t      | 8 byte     | 4 byte          | 8 byte    | 8 byte         |
 *    \============+============+=================+===========+================/
 *
 */

//
// data type
//
#define MOFString   const char *
#define MOFChar     char
#define MOFUChar    unsigned char

#define MOFByte     char
#define MOFUByte    unsigned char
#define MOFShort    short
#define MOFUShort   unsigned short
#define MOFInteger  int
#define MOFUInteger unsigned int
#define MOFFloat    float
#define MOFBool     char

#define MOFTrue     1
#define MOFFalse    0

// items count for dictionary/array
#define MOFArrayItemsCountMax      0xffff
#define MOFDictionaryItemsCountMax 0xffff

// items count for global
#define MOFItemsCountMax           0xffffffff

// max string length
#define MOFStringLengthMax         0xffff
// strings count for global string buffer
#define MOFStringsCountMax         0xffffffff

#define MOFStringNotFound          MOFStringsCountMax
#define MOFKeyNotFound             MOFStringsCountMax

//
// error code
//
enum {
	MOFCorrect         = 0,
	MOFErrorFormat     = 1 << 0,
	MOFErrorVersion    = 1 << 1,
	MOFErrorFileLength = 1 << 2,
	MOFErrorBufferInfo = 1 << 3,
};

//
// type for data item
//
typedef enum {
	MOFDataItemTypeKey,         // 0 (key for dictionary)
	
	MOFDataItemTypeArray,       // 1
	MOFDataItemTypeDictionary,  // 2
	
	MOFDataItemTypeString,      // 3
	MOFDataItemTypeInteger,     // 4
	MOFDataItemTypeFloat,       // 5
	MOFDataItemTypeBool,        // 6
	MOFDataItemTypeUnknown      // ?
} MOFDataItemType;

#pragma pack(1)

//
// string item in strings buffer
//
typedef struct {
	MOFUShort length;    // entire item length, includes 'sizeof(length)' and the last '\0' of string
	MOFChar   string[0]; // head of string buffer
} MOFStringItem;

//
// data item
//
typedef struct {
	MOFUByte        type;        // 0 - 255
	MOFUChar        reserved[3]; // reserved for bytes alignment
	union {
		// key (for dictionary)
		MOFUInteger keyId;       // 0 - 4,294,967,295 (4G)
		// string
		MOFUInteger stringId;    // 0 - 4,294,967,295 (4G)
		// count (for dictionary/array)
		MOFUShort   count;       // 0 - 65,535 (64K)
		// numeric
		MOFInteger  intValue;
		MOFUInteger uintValue;
		MOFFloat    floatValue;
		// bool
		MOFBool     boolValue;
	};
} MOFDataItem;

//
// data body
//
typedef struct {
	MOFUInteger offset; // offset of memory buffer (from data head)
	MOFUInteger length; // length of memory buffer (bytes)
} MOFBufferInfo;

typedef struct {
	MOFBufferInfo itemsBuffer;
	MOFBufferInfo stringsBuffer;
	
	MOFDataItem   items[0]; // head of item buffer
} MOFDataBody;

//
// data head
//
typedef struct {
	// protocol
	MOFUChar    format[4];   // "MOF"
	MOFUByte    version;
	MOFUByte    subVersion;
	MOFUChar    reserved[2]; // reserved for bytes alignment
	MOFUInteger fileLength;
	// info
	MOFUChar    description[64];
	MOFUChar    copyright[32];
	MOFUChar    author[32];
} MOFDataHead;

//
// MOF data
//
typedef struct {
	MOFDataHead head;
	MOFDataBody body;
} MOFData;

#pragma pack()

#endif
