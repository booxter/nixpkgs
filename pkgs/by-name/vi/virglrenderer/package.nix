{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  libGLU,
  libepoxy,
  libX11,
  libdrm,
  libgbm,
  nativeContextSupport ? stdenv.hostPlatform.isLinux,
  vaapiSupport ? !stdenv.hostPlatform.isDarwin,
  libva,
  vulkanSupport ? stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin,
  vulkan-headers,
  vulkan-loader,
  gitUpdater,
  moltenvk,
}:

stdenv.mkDerivation rec {
  pname = "virglrenderer";
  version = "1.1.1";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/slp/virglrenderer.git";
    rev = "d9752dd5fd4172e8a5694bbfb72be0e0a51f9ef3";
    hash = "sha256-ANGduHj+QYf8fVTLiT82qlPpFBA6fhukYtWa2gvZg6E=";
  };
  #src = fetchurl {
  #  url = "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/${version}/virglrenderer-${version}.tar.bz2";
  #  hash = "sha256-D+SJqBL76z1nGBmcJ7Dzb41RvFxU2Ak6rVOwDRB94rM=";
  #};

  #patches = [
  #  (fetchurl {
  #    url = "https://github.com/booxter/virglrenderer/commit/3029539505b1de3c5dfe2d44ed5686c875662708.patch";
  #    sha256 = "sha256-R+1dTgy/1+SMLyc92CuYKUfYdFZ1yBmIbDg4bCaw37Y=";
  #  })
  #  (fetchurl {
  #    url = "https://github.com/booxter/virglrenderer/commit/1d0ee20d2e91f58e778031178b7e0fcfef03fffd.patch";
  #    sha256 = "sha256-qlcci1rAB4A+Z14e6Bt8JFuqsHOZDr/07lQhW45kR8w=";
  #  })
  #];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "libdrm_dep = dependency('libdrm', version : '>=2.4.50', required: get_option('drm').enabled())" "" \
      --replace-fail "libdrm_dep.found()" "0"
    substituteInPlace src/meson.build \
      --replace-fail "libdrm_dep," ""
  '';

  separateDebugInfo = true;

  buildInputs =
    [
      libepoxy
      moltenvk
    ]
    ++ lib.optionals vaapiSupport [ libva ]
    ++ lib.optionals vulkanSupport [
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGLU
      libX11
      libgbm
      libdrm
    ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (python3.withPackages (ps: [
      ps.pyyaml
    ]))
  ];

  mesonFlags =
    [
      (lib.mesonBool "video" vaapiSupport)
      (lib.mesonBool "venus" vulkanSupport)
    ]
    ++ lib.optionals nativeContextSupport [
      (lib.mesonOption "drm-renderers" "amdgpu-experimental,msm")
    ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://gitlab.freedesktop.org/virgl/virglrenderer.git";
      rev-prefix = "virglrenderer-";
    };
  };

  meta = with lib; {
    description = "Virtual 3D GPU library that allows a qemu guest to use the host GPU for accelerated 3D rendering";
    mainProgram = "virgl_test_server";
    homepage = "https://virgil3d.github.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.xeji ];
  };
}
