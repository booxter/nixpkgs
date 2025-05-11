{
  lib,
  stdenv,
  gccStdenv,
  fetchFromGitHub,
  fetchurl,
  flex,
  bison,
  bc,
  cpio,
  perl,
  elfutils,
  python3,
  sevVariant ? false,
  writeTextFile,
  llvm,
  llvmPackages_20,
}:

let
  stdenv = llvmPackages_20.stdenv;
  darwin-byteswap-h = writeTextFile {
    name = "byteswap-h";
    text = ''
      #pragma once
      #include <libkern/OSByteOrder.h>
      #define bswap_16 OSSwapInt16
      #define bswap_32 OSSwapInt32
      #define bswap_64 OSSwapInt64
    '';
    destination = "/include/byteswap.h";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrunfw";
  version = "4.9.0";

  #src = if stdenv.hostPlatform.isLinux then (fetchFromGitHub {
  #  owner = "containers";
  #  repo = "libkrunfw";
  #  tag = "v${finalAttrs.version}";
  #  hash = "sha256-wmvjex68Mh7qehA33WNBYHhV9Q/XWLixokuGWnqJ3n0=";
  #}) else (fetchurl {
  #  url = "https://github.com/containers/libkrunfw/releases/download/v4.9.0/libkrunfw-4.9.0-prebuilt-aarch64.tar.gz";
  #  hash = "sha256-QvWbfqOnQkD8Mm+vpxuGhzR7poOXdikCyi/tTSdhMVw=";
  #});
  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrunfw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wmvjex68Mh7qehA33WNBYHhV9Q/XWLixokuGWnqJ3n0=";
  };

  patches = [
    ./enable-native-build-darwin.patch
  ];

  kernelSrc = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-6.12.20.tar.xz";
    hash = "sha256-Iw6JsHsKuC508H7MG+4xBdyoHQ70qX+QCSnEBySbasc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s $(kernelSrc) $(KERNEL_TARBALL)'
    substituteInPlace config-libkrunfw_aarch64 \
      --replace-fail 'CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y' 'CONFIG_CC_HAS_ZERO_CALL_USED_REGS=n'
  '';

  nativeBuildInputs = [
    flex
    bison
    bc
    cpio
    perl
    python3
    python3.pkgs.pyelftools
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages_20.lld
    llvm
  ];

  buildInputs = [
    #elfutils
  ];

  preBuild = ''
    mkdir -p elfutils
    tar xf ${elfutils.src} -C elfutils
    makeFlagsArray+=(HOSTCFLAGS="-D_UUID_T -D__GETHOSTUUID_H -I$(pwd)/elfutils/${elfutils.pname}-${elfutils.version}/libelf -I${darwin-byteswap-h}/include" CLANG_FLAGS='-fintegrated-as --target=aarch64-linux-gnu')
  '';

  hardeningDisable = lib.optional stdenv.hostPlatform.isAarch64 "zerocallusedregs";

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
    ]
    ++ lib.optionals sevVariant [
      "SEV=1"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      #"CC=${lib.getExe llvmPackages_20.clang-unwrapped}"
      "CC=${lib.getExe llvmPackages_20.clang}"
      "ARCH=arm64"
      "LLVM=1"
      #"CROSS_COMPILE=aarch64-linux-gnu-"
    ];

  # Fixes https://github.com/containers/libkrunfw/issues/55
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.targetPlatform.isAarch64 "-march=armv8-a+crypto";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/containers/libkrunfw";
    license = with licenses; [
      lgpl2Only
      lgpl21Only
    ];
    maintainers = with maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
    ];
    platforms = [ "x86_64-linux" ] ++ lib.optionals (!sevVariant) [ "aarch64-linux" ] ++ lib.platforms.darwin;
  };
})
