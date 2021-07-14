
# armv7l-toolchain.cmake
# This file is based on the following CMake toolchain files (Thank you)
# https://gist.github.com/mariospr/a93b211da627d9277b3b01ab04fe249b
# https://github.com/vpetrigo/arm-cmake-toolchains

# Set the directory to the ARM GCC compiler toolchain
set(TOOLCHAIN_DIR "$ENV{HOME}/gcc-linaro/7.3.1-arm-linux-gnueabihf")

if (NOT EXISTS "${TOOLCHAIN_DIR}")
    message(FATAL_ERROR "ARM GCC compiler does not exist: ${TOOLCHAIN_DIR}")
else()
    message(STATUS "Using ARM GCC compiler: ${TOOLCHAIN_DIR}")
endif()

set(SYSROOT_DIR ${TOOLCHAIN_DIR}/arm-linux-gnueabihf/libc)
set(TOOLS_DIR ${TOOLCHAIN_DIR}/bin)

# Setting the system name to "Linux" sets CMAKE_CROSSCOMPILING to true
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv7l)

# Specify the cross compilers
set(CMAKE_ASM_COMPILER ${TOOLS_DIR}/arm-linux-gnueabihf-gcc)
set(CMAKE_C_COMPILER ${TOOLS_DIR}/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${TOOLS_DIR}/arm-linux-gnueabihf-g++)

# This is very important, so that we find the right headers and libraries
# without explicitly listing the default include directories
set(CMAKE_SYSROOT ${SYSROOT_DIR})

# Ensure that FIND_PACKAGE() functions and friends look in the rootfs
# only for libraries and header files, but not for programs (e.g perl)
set(CMAKE_FIND_ROOT_PATH ${SYSROOT_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Set the compiler flags
message(STATUS "Adding a compiler flag: --sysroot=${SYSROOT_DIR}")
add_compile_options("--sysroot=${SYSROOT_DIR}")
message(STATUS "Adding compiler flags: -mfpu=neon -munaligned-access")
add_compile_options("-mfpu=neon")
add_compile_options("-munaligned-access")
message(STATUS "Adding a compiler definition: -D__NEON__")
add_compile_definitions("__NEON__")

set(CMAKE_STATIC_LINKER_FLAGS
    "${CMAKE_STATIC_LINKER_FLAGS} --sysroot=${SYSROOT_DIR}"
    CACHE INTERNAL "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS
    "${CMAKE_SHARED_LINKER_FLAGS} --sysroot=${SYSROOT_DIR}"
    CACHE INTERNAL "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} --sysroot=${SYSROOT_DIR}"
    CACHE INTERNAL "" FORCE)
