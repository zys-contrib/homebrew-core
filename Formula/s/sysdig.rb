class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/refs/tags/0.40.1.tar.gz"
  sha256 "f4d465847ba8e814958b5f5818f637595f3d78ce93dbc3b8ff3ee65a80a9b90f"
  license "Apache-2.0"
  head "https://github.com/draios/sysdig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "10e48ef9eeec0d5669fb74a701c7b56f14ecde55e5fac23ef18fed8b9151819c"
    sha256                               arm64_sonoma:  "a7f09c2dfd4ae9188473a982df684e6ffb13f90dd6a1888a0747972f01b2c87b"
    sha256                               arm64_ventura: "edde771b93afc34fe1f702a3d620a69f172f1406afdccdd9eee432cefeb9b126"
    sha256                               sonoma:        "cf22c0f58a531675d6ddd045c597caf8c1b2c993b42bfeb4a86b3353b974c923"
    sha256                               ventura:       "8852c89b06aa29c2c32b0b8a6d9f00344db8e7712ce5c8b5b818901710ad6ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293ea9eedf018f38f77d9c318520655cd0f1f16cb919cc3932e2f5d87fa47a50"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "falcosecurity-libs"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "ncurses" # for `newterm` function
  depends_on "yaml-cpp"

  on_macos do
    depends_on "re2"
    depends_on "tbb"
  end

  def install
    # Workaround to find some headers
    # TODO: Fix upstream to use standard paths, e.g. sinsp.h -> libsinsp/sinsp.h
    ENV.append_to_cflags "-I#{Formula["falcosecurity-libs"].opt_include}/falcosecurity/libsinsp"
    ENV.append_to_cflags "-I#{Formula["falcosecurity-libs"].opt_include}/falcosecurity/driver" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DDIR_ETC=#{etc}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # More info on https://gist.github.com/juniorz/9986999
    resource "homebrew-sample_file" do
      url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
      sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
    end

    testpath.install resource("homebrew-sample_file").files("sample.scap")
    output = shell_output("#{bin}/sysdig --read=#{testpath}/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
