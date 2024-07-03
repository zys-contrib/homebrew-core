class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "d7f6dd7d9e4465c1f44d168c3a38aad24569a25907673180c8791a783e73f02f"
  license "BSD-3-Clause"
  revision 1

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e0d2c8478ff2ed91cc63b0487b7efb8419ff795452b6af5aa9fa5b50e5abbd64"
    sha256 cellar: :any,                 arm64_ventura:  "2d6e94fd894eec0699cd3224d7aeb3e2de0f65923d3665ba803ebdafe98af8c0"
    sha256 cellar: :any,                 arm64_monterey: "f32293f353e053ccb8bad03754d880af62ea7c425dfc4e641810d5e890f98c5c"
    sha256 cellar: :any,                 sonoma:         "02d07cbf856898c8dd4a9a81a01457a6ec613e5cccc578659218d84031063f10"
    sha256 cellar: :any,                 ventura:        "5e72748c00e7ef3c6a2fea32768181a3b644b0618907caa42061b45d8fdeb38a"
    sha256 cellar: :any,                 monterey:       "3a5f6be6f0b625f838fceb0e89b052c0c561f89dfc878e1e94c870d9229bf2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f8dbf39fd5bf1dd7fffd476197f714572bfca9a50b93dbf0a91e9d4a469fe2c"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "opencascade"
  depends_on "vtk"

  on_macos do
    depends_on "freeimage"
    depends_on "freetype"
    depends_on "glew"
    depends_on "hdf5"
    depends_on "imath"
    depends_on "jsoncpp"
    depends_on "libaec"
    depends_on "netcdf"
    depends_on "tbb"
    depends_on "tcl-tk"
    depends_on "zstd"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{rpath}
      -DF3D_MACOS_BUNDLE:BOOL=OFF
      -DF3D_PLUGIN_BUILD_ALEMBIC:BOOL=ON
      -DF3D_PLUGIN_BUILD_ASSIMP:BOOL=ON
      -DF3D_PLUGIN_BUILD_OCCT:BOOL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "configuration"
    system "cmake", "--install", "build", "--component", "sdk"
  end

  test do
    # create a simple OBJ file with 3 points and 1 triangle
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render --geometry-only #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading.+obj/, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end
