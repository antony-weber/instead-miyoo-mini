/*
 * platform/onion_hash.c - OnionOS 32-bit path hashing utility for GameSwitcher
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

uint32_t onion_hash(const char *str)
{
	size_t len = strlen(str);
	const uint32_t CONST_M = 0x23462239;
	uint32_t r4 = 0x84222325;
	uint32_t r5 = 0xcbf29ce4;

	if (len <= 8) {
		uint8_t buf[8] = {0};
		memcpy(buf, str, len);
		uint32_t val_lo = *(uint32_t*)(buf);
		uint32_t val_hi = *(uint32_t*)(buf + 4);

		uint32_t r6 = val_lo ^ r4;
		uint32_t r7 = val_hi ^ r5;

		uint64_t prod = (uint64_t)r6 * CONST_M;
		uint32_t sl = (uint32_t)prod;
		uint32_t fp = (uint32_t)(prod >> 32) + r7 * CONST_M;

		uint32_t r0 = fp ^ sl;
		r0 ^= (r0 >> 16);
		return r0;
	}

	size_t r8 = ((len - 1) >> 4) + 1;
	r8 <<= 3;
	size_t r2 = len - r8;

	const uint8_t *p_start = (const uint8_t *)str;
	const uint8_t *p_end = p_start + r8;

	while (p_start < p_end) {
		uint32_t c1_lo = *(const uint32_t*)p_start;
		uint32_t c1_hi = *(const uint32_t*)(p_start + 4);

		uint32_t c2_lo = *(const uint32_t*)(p_start + r2);
		uint32_t c2_hi = *(const uint32_t*)(p_start + r2 + 4);

		r4 ^= c1_lo;
		r5 ^= c1_hi;

		uint64_t prod1 = (uint64_t)r4 * CONST_M;
		uint32_t r6 = (uint32_t)prod1;
		uint32_t r7 = (uint32_t)(prod1 >> 32) + r5 * CONST_M;

		r4 = r6 ^ c2_lo;
		r5 = r7 ^ c2_hi;

		uint64_t prod2 = (uint64_t)r4 * CONST_M;
		r4 = (uint32_t)prod2;
		r5 = (uint32_t)(prod2 >> 32) + r5 * CONST_M;

		p_start += 8;
	}

	uint32_t r0 = r5 ^ r4;
	r0 ^= (r0 >> 16);
	return r0;
}

int main(int argc, char **argv)
{
	if (argc < 2)
		return 1;
	printf("%u\n", onion_hash(argv[1]));
	return 0;
}
