class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.94.2.tar.gz"
  sha256 "5da5637266dd2641efe7bf3ddb7e39621fc3ba165e480cb7ed6e195be5c7f567"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7073be4a625b9264d1aef6796bc44eb73a44968165e7f85d73e9079171aa0c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dfd0e2e489aa925fd7b07cfe79a705598c34df3ebb19afc3707d37759636b02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d4479b8727f15b193961b11cfba0b0da7230921dbda6b949da547f0d4c00a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb254afc1597688aeb9034ab647c844b490e16e9d00390a7b3780301a49894a1"
    sha256 cellar: :any_skip_relocation, ventura:       "2acc96e6da622d76cff039867cab0c192946622437a95f9a725a536cd688cdda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8396320f45c4a7b9a9b5d8f17fab1ef0dea7a8413e90fee4798a9901ed3793b1"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
