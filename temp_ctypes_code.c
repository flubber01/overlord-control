
#include <stdio.h>
int stress_core(int val) {
    int sum = 0;
    for(int i = 0; i < val; i++) {
        sum += (i * 5) ^ 0xBC;
    }
    return sum;
}
