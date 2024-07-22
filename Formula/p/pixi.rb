class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "f432eed9e0206d87ea548ad313b274874f4a0e8f499478597a197e0c84372b1d"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "685880645ba83c321e6a440fe040e3c6f06eb9667929a8d0ec1f01a23d443c07"
    sha256 cellar: :any,                 arm64_ventura:  "bed05569122885b4867126827feecc44e9f822f36e12847e961f334f57e22756"
    sha256 cellar: :any,                 arm64_monterey: "c791e55ce59322d9dcc79c45d9a03573232c2a3709ca95cc15009b45ed55bf6e"
    sha256 cellar: :any,                 sonoma:         "29bef1bf40b01ca56124978630ec1f5849ac8ce86a3ca4afc9b4798c95eda9d2"
    sha256 cellar: :any,                 ventura:        "121555b3a6b143f89c84b86c6e208d14b614258ab54fea5bafbcaafc9527a33f"
    sha256 cellar: :any,                 monterey:       "b245c368f52c80f5d5000d57bbc82404a2e5e0c27628feeebaa32df6169e25ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd31ee3c22e4464c0da0ad59d73f35260e22917666cabb574db71f6994edc169"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
