class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "b4a109c219775b7a011f0960d88120b2593923181888c50fe1b76f927dd7201c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d9533b804ea0564568855e688ac84a63868b7f183adc34704571004999e652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9feb752511e2b769fb6dda9bd8866db7d7b5513a62ef81686f0b51522722019a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca98ec625765547b81287181cb629e359445544ca301335f22dd729913d57d3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddc1cbf70aeb28f0923711a7cadd8cac9ec90a5ca059ef2a999195a815ff0c21"
    sha256 cellar: :any_skip_relocation, ventura:       "d0af57e7844fdc8f6300f6cb193033a5eaf9e403f389bb5818c99e89f1fb5ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d5a51d87b3e58aec9985a8c2ad7594b184457c3cce166d3e568230a34ac1e92"
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
