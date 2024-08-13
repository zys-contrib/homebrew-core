class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "20ab38fa94daedf2965997c487223831035028de93ddf73c6b92e68558e229f7"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cde071917f80a4e31c593cdc0675570276f15c7c8c6841ba70abf5c3e333ba84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73e722907d8a17d81cd350e7685a13379192bb0377036844356ba27e83edd90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e758896d15c2a7e17c81c518158559cd3965ffcaf7f90500ca8d36331dc1ecd"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f22832cde123574b6da481d2d5274337a06676d0f320cab7d8addefd7229efc"
    sha256 cellar: :any_skip_relocation, ventura:        "80674c6f909e5d8801d2c949742fc7c368c6b3e6acf1e4fe6d151eca08c14a03"
    sha256 cellar: :any_skip_relocation, monterey:       "9eb573e37b032fcd17b1931e28384ffeed281622576835774e3a6355b945512e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a70f08f420f32855e3317e2ece4e3bd7f81573dd0f35afb007c1d91a8a1012"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "Error: Failed to list store contents: operation error SSM", output

    assert_match version.to_s, shell_output("#{bin}/chamber version")
  end
end
