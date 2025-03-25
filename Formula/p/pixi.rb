class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.43.3.tar.gz"
  sha256 "728b22806c5c3978c14362bb406c6ff4e11f1cf7bf031928a40dc883a09a8840"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cb3cb491c93648ca344e79751f1c076d10b1dabde7b4ccc7c7605598c6e0282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c06aa2cc4ab9230c1eb3fb90617d1096b8262d8eb6842b4b26d0fc60f0adfa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9267c655051effb3aa84188daa7ed220775aa27fac49e37b8aa1cf482111e013"
    sha256 cellar: :any_skip_relocation, sonoma:        "71e7b1c97d9358f90bc63316841179d0188cfaedf079beef7b63be0fa4788710"
    sha256 cellar: :any_skip_relocation, ventura:       "acfc052d1554bbb550461c05c71b514ec8ff0d9d5cbd2ed9db6acbce5060ba4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d79f87993a16dcadf1eaa642c73a32eca2a4443e2f7de02768b5a259b98114b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03791067f1a78495f76b84acdab9fe518ca8d1837bcd79d11cfbb530e0e4f43e"
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
