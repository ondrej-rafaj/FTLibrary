//
//  FTMemTools.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 23.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import "FTMemTools.h"
#include <sys/sysctl.h>  
#include <mach/mach.h>


@implementation FTMemTools

+ (void)logMemory:(NSString *)ident {
	NSLog(@"%@: %d Kb", ident, ([self getAvailableMemory] / 1024));
}

+ (void)logMemoryInFunction:(NSString *)function {
	NSLog(@"Memory log for %@: %d", function, [self getAvailableMemory]);
}

+ (natural_t)getAvailableMemory {
	mach_port_t host_port;
	mach_msg_type_number_t host_size;
	vm_size_t pagesize;
	host_port = mach_host_self();
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
	host_page_size(host_port, &pagesize);
	vm_statistics_data_t vm_stat;
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
		NSLog(@"Memory log: Failed to fetch vm statistics");
		return -1;
	}
	// Stats in bytes
	natural_t mem_free = vm_stat.free_count * pagesize;
	return mem_free;
}

+ (natural_t)getAvailableMemoryInKb {
	return [self getAvailableMemory] / 1024;
}


@end
