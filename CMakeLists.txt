
# CMakeLists.txt

cmake_minimum_required(VERSION 3.10)

project(arm_neon_cross_test CXX)

# Find Neon 
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})
find_package(ARM)

add_executable(arm_neon_test ${PROJECT_SOURCE_DIR}/main.cpp)
target_compile_features(arm_neon_test PUBLIC cxx_std_17)
target_compile_options(arm_neon_test PUBLIC
    -pedantic -Wall -Wextra -Wno-psabi -O3)
target_compile_options(arm_neon_test PUBLIC -DUSE_NEON)

add_executable(no_neon_test ${PROJECT_SOURCE_DIR}/main.cpp)
target_compile_features(no_neon_test PUBLIC cxx_std_17)
target_compile_options(no_neon_test PUBLIC
    -pedantic -Wall -Wextra -Wno-psabi -O3)
