class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "906f2bdb7866c58d16b7b3643f9ec19455384a9a4a50e1bf6bf59cd3914076a7"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fec290343a1a8dbc375dc4faba2ae251f8961e5772f0bf0de34d70f9ce3cc139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e046dbba28e70b74cdc3835fe109660b2e867ede346361fdaed2fe03446b5f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5d1e821658aae921875d488b9ab5ef79f4bf01f3df765d8dec1f8b08d235ae7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2a772a19564489c6c1ecf9ff0a2afee5737061ca72b399248c6638ad0bd59da"
    sha256 cellar: :any_skip_relocation, ventura:        "cc75c3431d74e115127b5960d95943ec626fd2d88291da44f925481b7b8265a4"
    sha256 cellar: :any_skip_relocation, monterey:       "12461cec08dd41774cc591847d1b0d00f9e0de58ee465ee842223d6a691b0a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22e48a8cf7360eace9ea21000f46b70b0c5eb8b1cc5d2fef0f6952c8e3d8517"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
