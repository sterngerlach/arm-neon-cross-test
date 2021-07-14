
# arm-neon-cross-test
Pynq-Z2 (ARM Cortex-A9, armv7l) 用のソースコードを, Ubuntu 20.04上でクロスコンパイルしてみるためのテスト用のリポジトリ.

- クロスコンパイル用のツールチェイン (GCC/Linaro 7.3.1) を以下のサイトからダウンロードして, ホームディレクトリ以下の `gcc-linaro/7.3.1-arm-linux-gnueabihf` ディレクトリに配置する.
  - https://releases.linaro.org/components/toolchain/gcc-linaro/7.3-2018.05/

  ```
  $ cd
  $ mkdir gcc-linaro
  $ cd gcc-linaro
  $ wget https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-i686_arm-linux-gnueabihf.tar.xz
  $ tar xvf gcc-linaro-7.3.1-2018.05-i686_arm-linux-gnueabihf.tar.xz
  $ mv gcc-linaro-7.3.1-2018.05-i686_arm-linux-gnueabihf 7.3.1-arm-linux-gnueabihf
  ```

- このリポジトリを適当な場所にクローンし, CMakeを使ってビルドする. 以下は, ホームディレクトリ直下にクローンした例であり, `user` の箇所は, 現在のユーザ名になる.
オプション `-DCMAKE_TOOLCHAIN_FILE` に, リポジトリ内のツールチェインファイル `armv7l-toolchain.cmake` を指定する.
  ```
  $ cd
  $ cd arm-neon-cross-test
  $ mkdir build
  $ cd build
  $ cmake .. -DCMAKE_TOOLCHAIN_FILE=../armv7l-toolchain.cmake
  -- Using ARM GCC compiler: /home/user/gcc-linaro/7.3.1-arm-linux-gnueabihf
  -- Adding a compiler flag: --sysroot=/home/user/gcc-linaro/7.3.1-arm-linux-gnueabihf/arm-linux-gnueabihf/libc
  -- Adding compiler flags: -mfpu=neon -munaligned-access
  -- Adding a compiler definition: -D__NEON__
  -- Using ARM GCC compiler: /home/user/gcc-linaro/7.3.1-arm-linux-gnueabihf
  -- Adding a compiler flag: --sysroot=/home/user/gcc-linaro/7.3.1-arm-linux-gnueabihf/arm-linux-gnueabihf/libc
  -- Adding compiler flags: -mfpu=neon -munaligned-access
  -- Adding a compiler definition: -D__NEON__
  -- The CXX compiler identification is GNU 7.3.1
  -- Check for working CXX compiler: /home/user/gcc-linaro/7.3.1-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++
  -- Check for working CXX compiler: /home/user/gcc-linaro/7.3.1-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++ -- works
  -- Detecting CXX compiler ABI info
  -- Detecting CXX compiler ABI info - done
  -- Detecting CXX compile features
  -- Detecting CXX compile features - done
  -- Neon intrinsics not found on this machine.
  -- Asimd/Neon not found on this machine.
  -- OMAP3 processor not found on this machine.
  -- OMAP4 processor not found on this machine.
  -- Configuring done
  -- Generating done
  -- Build files have been written to: /home/user/arm-neon-cross-test/build

- `.vscode/c_cpp_properties.json` には, Visual Studio Codeでの開発を容易にするための, Intellisenseの設定が含まれている.
ARM Neon Intrinsicsの関数群 (`vld1q_f32` や `vmulq_f32` など) が補完されるようになる.
