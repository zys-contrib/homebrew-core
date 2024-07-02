class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "d7f6dd7d9e4465c1f44d168c3a38aad24569a25907673180c8791a783e73f02f"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8456d3aaeeea2ec816e083e2d2005d9ed2940282706e19531834db86141a953"
    sha256 cellar: :any,                 arm64_ventura:  "b182344007d4fe0a1040e94944bfd0b38b3725e1805f29e909cbf35bc19cde57"
    sha256 cellar: :any,                 arm64_monterey: "df78c97b486eb22be12d929f92e84f635e0f90d6bbdc8d92da6077a40f7d33f3"
    sha256 cellar: :any,                 sonoma:         "b8e5d4dfc12e6a5318a3f9592a176eadb11346ad29e11eca3ab5115d8335c344"
    sha256 cellar: :any,                 ventura:        "661157c0d070e2592193335151a7e9646e2d3537426566e743cffd79e2738f04"
    sha256 cellar: :any,                 monterey:       "483ef8a4631c4316fe611b774b3a0a4aba77cebcc90a63711f1d15c78204993b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2526e2052e571406b6d31c6460541ddb04f995e5acf8259f1c65f44b9a626483"
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
