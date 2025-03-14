class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "f2c8f7e549da1a9c3891ae679bad2a875593781b260f7e65c83bbfb913623e1a"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa13247fde055537e28dd109afb3d463eefc292f9716d7e4e5d2c9387afaf50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa13247fde055537e28dd109afb3d463eefc292f9716d7e4e5d2c9387afaf50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fa13247fde055537e28dd109afb3d463eefc292f9716d7e4e5d2c9387afaf50"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fae0a61d63dcd339ab9c61a09998e5b90e8a367e8ead13c85b746e978fc0a1c"
    sha256 cellar: :any_skip_relocation, ventura:       "2fae0a61d63dcd339ab9c61a09998e5b90e8a367e8ead13c85b746e978fc0a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30b6c4fe1b8c2dfaeda489dcb652ed5fc9a75936362fb07ea02d140f65793c34"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first

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
