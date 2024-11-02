class Intercept < Formula
  desc "Static Application Security Testing (SAST) tool"
  homepage "https://intercept.cc"
  url "https://github.com/xfhg/intercept/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "2732a3e895a9685ba6f112e7e372627aebfa340a94bf4716462b382075593308"
  license "EUPL-1.2"
  version_scheme 1
  head "https://github.com/xfhg/intercept.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "462d8ea33b9bc231246f675b27aae0410bc3533f7936ddb325825676b7dc6e4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b9f713421eb60a9f282382c984910102b4ee038a9696646692a58f95b60deb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ffd7963af43fd4e77eac4bedc85b02a8464eb2ba5d68794e9fe2efea1639d2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a11dd7aa846ced12af4e9f7e86ff34a64af742687df91e37b6147d310db1b95"
    sha256 cellar: :any_skip_relocation, ventura:        "8a75a820f8305407af68d2fd1af865e785281de68a88a36e9a19e76638206844"
    sha256 cellar: :any_skip_relocation, monterey:       "2c9cb3a1eb2649a7d6a94cadc651f260b0778f784d9f25117cf2c9f4ee42f4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f0ae352d17745513393daf0a38051c8b7aa753fc9154af446470d474585731"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"intercept", "completion")

    pkgshare.install "playground"
  end

  test do
    cp_r "#{pkgshare}/playground", testpath
    cd "playground" do
      output = shell_output("#{bin}/intercept audit --policy policies/test_scan.yaml " \
                            "--target targets -vvv audit 2>&1")
      assert_match "Total Policies: 2", output
    end
  end
end
