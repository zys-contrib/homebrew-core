class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "c336b166b9f675732f0ff2c0e1dddfacc13feb2d52b30c380240690d84edde0c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1812adfd2cd4fb4b9b5d1c08a82710c3feaa01d90665db037fe06d79f63a08a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0453764420d58fdb6b2fb08ff04a0bb88bbecaf402d895e312922aba90991ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c46d7bb36edfbee9671ebcb5ec2f99785243f9a78a95229a41797079d8830af"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1360a90205fa0b532f27df4845aaa1d38764675ae4f251430fa3ce1c015422d"
    sha256 cellar: :any_skip_relocation, ventura:       "9d614f194670110d8d21ebb05d4498d65f9bf0b39a21cea5548c76b32cda89e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1e6e0da33392eb3e7f9ad746070a9d00d5d0ba5534807979bea0958df964204"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
