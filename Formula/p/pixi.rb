class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.40.3.tar.gz"
  sha256 "b7cff3f4dd3a1e164f1088d07fe4d20b5830855d481b0811d979074ab0d3bc08"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41adf0e94f61633891928b08ad1c8e4929e68f3571cbdb73d2572c90299fa73f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43f7f62488c5db84b20fb9df15985c8cd50d6684bfa4c0481e61433075a671f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a9e8036536a35d7d6b02fac888e36905713d5900e5fdf2885e538426482e51b"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d0b9aa3fba67419ec93ac2388440f90d63c46a42f86cf17c1c2729540705db"
    sha256 cellar: :any_skip_relocation, ventura:       "60b1280d5956e8e9f79c18ea5afd920ef4da9debc268182ad926d661892124a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce1d718e45dbcebbf69587142dadb5b31243eadde3c1106bb81db697f966431"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

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
