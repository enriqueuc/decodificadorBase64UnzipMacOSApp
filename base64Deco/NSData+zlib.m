@import Foundation;

#import <zlib.h>

#import "NSData+zlib.h"
#import "zlib.h"

@implementation NSData (zlib)

-(NSData *)gzipDecompress
{
    if(self.length == 0)
    {
        return self;
    }
    
    int status;
    BOOL done = NO;
    unsigned full_length = (unsigned)self.length;
    unsigned half_length = (unsigned)(self.length / 2);
    NSMutableData *decompressed = [NSMutableData dataWithLength:full_length + half_length];
    
    z_stream strm;
    strm.next_in = (Bytef *)self.bytes;
    strm.avail_in = (uInt)self.length;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if(inflateInit2(&strm, (15 + 32)) != Z_OK)
    {
        return nil;
    }
    
    while(!done)
    {
        // Make sure we have enough room and reset the lengths.
        if(strm.total_out >= decompressed.length)
        {
            [decompressed increaseLengthBy:half_length];
        }
        strm.next_out = decompressed.mutableBytes + strm.total_out;
        strm.avail_out = (uInt)(decompressed.length - strm.total_out);
        
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if(status == Z_STREAM_END)
        {
            done = YES;
        }
        else if(status != Z_OK)
        {
            break;
        }
    }
    
    if(inflateEnd(&strm) != Z_OK)
    {
        return nil;
    }
    
    // Set real length.
    if(done)
    {
        decompressed.length = strm.total_out;
        return decompressed;
    }
    
    return nil;
}


@end
