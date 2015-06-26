//
//  mof_data.h
//  MemoryObjectFile
//
//  Created by Moky on 14-12-8.
//  Copyright (c) 2014 Slanissue.com. All rights reserved.
//

#ifndef __mof_data__
#define __mof_data__

#include "mof_protocol.h"

MOFData * mof_create (const MOFUInteger buf_len); // create an initialized buffer
void      mof_destroy(void * data); // destroy a buffer

MOFInteger mof_check (const MOFData * data); // check data format, 0 means correct

#pragma mark - Input/Output

const MOFData * mof_load(const char * __restrict filename);
MOFInteger      mof_save(const char * __restrict filename, const MOFData * data);

#pragma mark - getters

const MOFDataItem * mof_item(const MOFUInteger index, const MOFData * data); // get item with global index
const MOFDataItem * mof_root(const MOFData * data); // get root item (the first item)

const MOFDataItem * mof_items_start(const MOFData * data); // get first item
const MOFDataItem * mof_items_end  (const MOFData * data); // get tail of items (next of the last item)

#pragma mark values

MOFCString  mof_key  (const MOFDataItem * item, const MOFData * data); // get key with item (for dictionary)
MOFCString  mof_str  (const MOFDataItem * item, const MOFData * data); // get string with item
MOFInteger  mof_int  (const MOFDataItem * item); // get integer with item
MOFUInteger mof_uint (const MOFDataItem * item); // get unsigned integer with item
MOFFloat    mof_float(const MOFDataItem * item); // get float with item
MOFBool     mof_bool (const MOFDataItem * item); // get bool with item

#endif /* defined(__mof_data__) */
