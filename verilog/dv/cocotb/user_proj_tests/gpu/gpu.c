// SPDX-FileCopyrightText: 2023 Efabless Corporation

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#include <stdint.h>
#include <stdbool.h>
#include <firmware_apis.h>

// Note that all C arrays are transposed from the actual multiplier objects

static inline void USER_write_u32(uint32_t data, int offset) {
    ((volatile uint32_t *) USER_SPACE_ADDR)[offset] = data;
}

static inline uint32_t USER_read_u32(int offset) {
    return ((volatile uint32_t *) USER_SPACE_ADDR)[offset];
}

static inline void write_mat_col(const int16_t data[4], int mat, int col) {
    uint32_t data_0 =
        ((uint32_t) (uint16_t) data[0] <<  0) |
        ((uint32_t) (uint16_t) data[1] << 16);
    uint32_t data_1 =
        ((uint32_t) (uint16_t) data[2] <<  0) |
        ((uint32_t) (uint16_t) data[3] << 16);
    mat %= 4;
    col %= 4;
    USER_write_u32(data_0, 0x00000000 + ((mat << 2 | col) << 1) + 0);
    USER_write_u32(data_1, 0x00000000 + ((mat << 2 | col) << 1) + 1);
}

static inline void read_mat_col(int16_t data[4], int mat, int col) {
    mat %= 4;
    col %= 4;
    uint32_t data_0 = USER_read_u32(0x00000000 + ((mat << 2 | col) << 1) + 0);
    uint32_t data_1 = USER_read_u32(0x00000000 + ((mat << 2 | col) << 1) + 1);
    data[0] = (data_0 >>  0) & 0xFFFF;
    data[1] = (data_0 >> 16) & 0xFFFF;
    data[2] = (data_1 >>  0) & 0xFFFF;
    data[3] = (data_1 >> 16) & 0xFFFF;
}

static inline void do_mat_mul(int mat_a, int mat_b, int col_b, int mat_c, int col_c) {
    mat_a %= 4;
    mat_b %= 4;
    col_b %= 4;
    mat_c %= 4;
    col_c %= 4;
    USER_write_u32(
        0x00002000 |
        mat_c << 10 | col_c <<  8 |
        mat_b <<  6 | col_b <<  4 |
        mat_a <<  2,
        0x00000020);
}

static inline void put_hex(uint8_t nibble) {
    if (nibble < 10) {
        putchar(nibble - 0x0 + '0');
    } else {
        putchar(nibble - 0xA + 'A');
    }
}

void process_mul(const int16_t a[4][4], const int16_t b[4], int16_t c[4]) {
    // Write A
    for (int i = 0; i < 4; ++i) {
        write_mat_col(a[i], 0, i);
    }

    // Write B
    write_mat_col(b, 1, 0);

    // Perform operation
    do_mat_mul(
        0,
        1, 0,
        2, 0
    );

    // Read C
    read_mat_col(c, 2, 0);
}

unsigned int
__mulsi3 (unsigned int a, unsigned int b)
{
  unsigned int r = 0;

  while (a)
    {
      if (a & 1)
	r += b;
      a >>= 1;
      b <<= 1;
    }
  return r;
}

static inline int16_t mul_4p12(int16_t a, int16_t b) {
    int32_t a_ext = a;  // 20p12
    int32_t b_ext = b;  // 20p12
    int32_t c_ext = a_ext * b_ext;  // 8p24
    int16_t c = (c_ext >> 12) & 0xFFFF;
    return c;
}

static void fake_process_mul(const int16_t a[4][4], const int16_t b[4], int16_t c[4]) {
    for (int j = 0; j < 4; ++j) {
        c[j] = 0;
    }

    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            c[j] += mul_4p12(a[i][j], b[i]);
        }
    }
}

void main() {
    ManagmentGpio_write(0);
    ManagmentGpio_outputEnable();
    GPIOs_configure(6,GPIO_MODE_MGMT_STD_OUTPUT);
    GPIOs_loadConfigs();
    User_enableIF();
    UART_enableTX(1);
    ManagmentGpio_write(1); // configuration finished 

    const int16_t a[4][4] = {
        { 0x0000, 0x1000, 0x2000, 0x3000 },
        { 0x4000, 0x5000, 0x6000, 0x7000 },
        { 0x0000, 0x0100, 0x0200, 0x0300 },
        { 0x0040, 0x0050, 0x0060, 0x0070 }
    };
    const int16_t b[4] = { 0x0040, 0x0030, 0x0020, 0x0010 };
    int16_t c_real[4];
    int16_t c_fake[4];
    process_mul(a, b, c_real);
    fake_process_mul(a, b, c_fake);

    bool all_zero = true;
    bool is_good = true;
    for (int i = 0; i < 4; ++i) {
        if (c_real[i] != c_fake[i]) {
            is_good = false;
        }
        if (c_real[i] != 0 || c_fake[i] != 0) {
            all_zero = false;
        }
    }
    if (is_good && !all_zero) {
        print("Yay\n");
    } else {
        print("Boo");
        if (!is_good) {
            print(" mismatch");
        }
        if (all_zero) {
            print(" all-zero");
        }
        print("\n");
    }

    // for (int i = 16 - 4; i >= 0; i -= 4) {
    //     uint8_t nibble = (c_real[3] >> i) & 0xF;
    //     put_hex(nibble);
    // }
    // for (int i = 16 - 4; i >= 0; i -= 4) {
    //     uint8_t nibble = (c_real[2] >> i) & 0xF;
    //     put_hex(nibble);
    // }
    // for (int i = 16 - 4; i >= 0; i -= 4) {
    //     uint8_t nibble = (c_real[1] >> i) & 0xF;
    //     put_hex(nibble);
    // }
    // for (int i = 16 - 4; i >= 0; i -= 4) {
    //     uint8_t nibble = (c_real[0] >> i) & 0xF;
    //     put_hex(nibble);
    // }
    // putchar('\n');

    return;
}