
/* main.cpp */

#include <chrono>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <numeric>

#ifdef __NEON__
#include <arm_neon.h>
#endif

/* Defines in c_cpp_properties.json are obtained as follows: */
/* arm-linux-gnueabihf-gcc -E -dM - < /dev/null | sort > no-neon.txt */
/* arm-linux-gnueabihf-gcc -E -dM -mfpu=neon - < /dev/null | sort > neon.txt */
/* diff no-neon.txt neon.txt */

/* Project can be built using: */
/* cmake .. -DCMAKE_TOOLCHAIN_FILE=../armv7l-toolchain.cmake */

const int kArraySize = 1 << 21;

#ifdef __NEON__

void AddNeon(const float* array0, const float* array1, float* array2)
{
    for (int i = 0; i < kArraySize; i += 4) {
        float32x4_t v0 = ::vld1q_f32(array0 + i);
        float32x4_t v1 = ::vld1q_f32(array1 + i);
        float32x4_t v2 = ::vmulq_f32(v0, v1);
        ::vst1q_f32(array2 + i, v2);
    }
}

#endif

void Add(const float* array0, const float* array1, float* array2)
{
    for (int i = 0; i < kArraySize; ++i)
        array2[i] = array0[i] * array1[i];
}

int main()
{
    float* array0 = new float[kArraySize];
    float* array1 = new float[kArraySize];
    float* array2 = new float[kArraySize];

    std::fill(array0, array0 + kArraySize, 4.0f);
    std::iota(array1, array1 + kArraySize, 0.5f);

    std::cerr << std::fixed << std::setprecision(1);

#ifdef USE_NEON
    /* Parallelization using ARM Neon intrinsics */
    std::cerr << "Vectorized using ARM Neon intrinsics\n";
    auto startTime0 = std::chrono::steady_clock::now();

    AddNeon(array0, array1, array2);

    auto endTime0 = std::chrono::steady_clock::now();
    auto elapsed0 = std::chrono::duration_cast<
        std::chrono::milliseconds>(endTime0 - startTime0).count();

    std::cerr << "Elapsed time: " << elapsed0 << " ms\n";

    for (int i = 0; i < 10; ++i)
        std::cerr << "array2[" << i << "]: " << array2[i] << "\n";
    for (int i = kArraySize - 10; i < kArraySize; ++i)
        std::cerr << "array2[" << i << "]: " << array2[i] << "\n";
#else
    std::cerr << "Not vectorized version\n";
    auto startTime1 = std::chrono::steady_clock::now();

    Add(array0, array1, array2);

    auto endTime1 = std::chrono::steady_clock::now();
    auto elapsed1 = std::chrono::duration_cast<
        std::chrono::milliseconds>(endTime1 - startTime1).count();

    std::cerr << "Elapsed time: " << elapsed1 << " ms\n";

    for (int i = 0; i < 10; ++i)
        std::cerr << "array2[" << i << "]: " << array2[i] << "\n";
    for (int i = kArraySize - 10; i < kArraySize; ++i)
        std::cerr << "array2[" << i << "]: " << array2[i] << "\n";
#endif

    delete[] array0;
    delete[] array1;
    delete[] array2;

    return EXIT_SUCCESS;
}
