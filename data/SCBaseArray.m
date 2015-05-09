//
//  SCBaseArray.m
//  SnowCat
//
//  Created by Moky on 15-5-8.
//  Copyright (c) 2015 Moky. All rights reserved.
//

#include <stdlib.h>
#include <string.h>

#import "SCLog.h"
#import "SCBaseArray.h"

SCBaseArray * SCBaseArrayCreate(unsigned long itemSize, unsigned long capacity)
{
	SCBaseArray * array = (SCBaseArray *)malloc(sizeof(SCBaseArray));
	memset(array, 0, sizeof(SCBaseArray));
	array->maxCount = capacity;
	array->itemSize = itemSize;
	array->items = (SCBaseType *)calloc(capacity, itemSize);
	return array;
}

void SCBaseArrayExpand(SCBaseArray * array)
{
	array->maxCount *= 2;
	array->items = (SCBaseType *)realloc(array->items, array->maxCount);
}

void SCBaseArrayDestroy(SCBaseArray * array)
{
	free(array->items);
	array->items = NULL;
	free(array);
}

SCBaseType * SCBaseArrayItemAt(const SCBaseArray * array, unsigned long index)
{
	return index < array->count ? array->items + index * array->itemSize : NULL;
}

void SCBaseArrayAdd(SCBaseArray * array, const SCBaseType * item)
{
	if (array->count >= array->maxCount) {
		SCBaseArrayExpand(array);
	}
	SCBaseType * ptr = array->items + array->count * array->itemSize;
	
	// append item to tail
	if (array->fnAssign) {
		array->fnAssign(ptr, item);
	} else if (array->bkAssign) {
		array->bkAssign(ptr, item);
	} else {
		//SCLog(@"ERROR: no assign method");
		return;
	}
	array->count += 1;
}

void SCBaseArrayInsert(SCBaseArray * array, const SCBaseType * item, unsigned long index)
{
	if (index >= array->count) {
		SCBaseArrayAdd(array, item);
		return;
	}
	if (array->count >= array->maxCount) {
		SCBaseArrayExpand(array);
	}
	
	// move the rest data backwords from index
	SCBaseType * src = array->items + index * array->itemSize;
	SCBaseType * dest = src + array->itemSize;
	unsigned long len = (array->count - index) * array->itemSize;
	memmove(dest, src, len);
	
	// insert item at index
	if (array->fnAssign) {
		array->fnAssign(src, item);
	} else if (array->bkAssign) {
		array->bkAssign(src, item);
	} else {
		//SCLog(@"ERROR: no assign method");
		return;
	}
	array->count += 1;
}

void SCBaseArrayRemove(SCBaseArray * array, unsigned long index)
{
	if (index >= array->count) {
		//SCLog(@"index out of range: %u > %u", (unsigned int)index, (unsigned int)array->count);
		return;
	}
	
	// move the rest data forwards to index
	SCBaseType * dest = array->items + index * array->itemSize;
	SCBaseType * src = dest + array->itemSize;
	unsigned long len = (array->count - index - 1) * array->itemSize;
	memmove(dest, src, len);
	
	array->count -= 1;
}

void SCBaseArraySort(SCBaseArray * array)
{
	// quick sort
	if (array->fnCompare) {
		qsort(array->items, 0, array->count - 1, array->fnCompare);
	} else if (array->bkCompare) {
		qsort_b(array->items, 0, array->count - 1, array->bkCompare);
	} else {
		//SCLog(@"ERROR: no compare method");
	}
}

void SCBaseArraySortInsert(SCBaseArray * array, const SCBaseType * item)
{
	// seek
	long index = array->count - 1;
	SCBaseType * ptr = array->items + index * array->itemSize;
	
	if (array->fnCompare) {
		for (; index >= 0; --index, ptr -= array->itemSize) {
			if (array->fnCompare(ptr, item) <= 0) {
				break; // got it
			}
		}
	} else if (array->bkCompare) {
		for (; index >= 0; --index, ptr -= array->itemSize) {
			if (array->bkCompare(ptr, item) <= 0) {
				break; // got it
			}
		}
	} else {
		//SCLog(@"ERROR: no compare method");
		return;
	}
	
	// the item at index is smaller(or equals), insert after it
	SCBaseArrayInsert(array, item, index + 1);
}
