#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 10
#define LOWER_BOUND 0
#define UPPER_BOUND 100

int main() {
    int random_array[ARRAY_SIZE];
    double avg_init = 0.0;

    // Seed the random number generator
    srand(time(NULL));

    // Generate array of random numbers
    for (int i = 0; i < ARRAY_SIZE; i++) {
        random_array[i] = rand() % (UPPER_BOUND - LOWER_BOUND) + LOWER_BOUND;
        avg_init += random_array[i];
    }
    avg_init /= ARRAY_SIZE;

    printf("Random array: ");
    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%d ", random_array[i]);
    }
    printf("\nInitial Average: %f\n", avg_init);

    for (int x = 0; x < 5; x++) {
        int rando = rand() % (UPPER_BOUND - LOWER_BOUND) + LOWER_BOUND;

        // part 1: calculate average
        double data_diff = rando - random_array[x];
        double data_diff_weighted = data_diff / 10;
        double avg_calculated = avg_init + data_diff_weighted;

        // part 2: overwrite average
        random_array[x] = rando;
        avg_init = 0.0;
        for (int i = 0; i < ARRAY_SIZE; i++) {
            avg_init += random_array[i];
        }
        avg_init /= ARRAY_SIZE;

        // Print (diff: 0 IS GOOD)
        double bad_num = avg_calculated - avg_init;
        printf("diff: %f\n", bad_num);
        printf("data_diff: %f\n", data_diff);
    }

    return 0;
}