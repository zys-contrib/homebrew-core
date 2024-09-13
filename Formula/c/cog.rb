class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.22.tar.gz"
  sha256 "021989f2b2571b3dc90d76de0ea28bef56cb48ed1514e0c2403376e586c0db12"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4d239a2c42357d3b9c127819f45831069cf129ba7983e011289c2c68a05ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4d239a2c42357d3b9c127819f45831069cf129ba7983e011289c2c68a05ecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa4d239a2c42357d3b9c127819f45831069cf129ba7983e011289c2c68a05ecb"
    sha256 cellar: :any_skip_relocation, sonoma:        "618face0091632fd9e2d4f27f851bdf626dd3d8a678ac121b51f023294d3332d"
    sha256 cellar: :any_skip_relocation, ventura:       "618face0091632fd9e2d4f27f851bdf626dd3d8a678ac121b51f023294d3332d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b9e6ff100bc5fec6f46dea9f85987c6b0094345019269439644e2df02c863e"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def install
    python3 = "python3.12"

    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first => "cog.whl"

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
