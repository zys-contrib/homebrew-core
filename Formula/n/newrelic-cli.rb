class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.17.tar.gz"
  sha256 "36dd80e5594c1c4336061d4a0eb3dadc14ecb80af6dd6000e90087d1934d526f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44ae443da117fefb690c927bbdbcaa7a0a0416d61ff6e6ee7817cd5f81509fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d035e6c5d60cde114d7acc7cec03d431058aea0f3e968a3fbbd60b751f5ff6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df1462b90e9a31bca4164f8c55fc4dfb4d86a9a918913bc8d20f11a91d58e861"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe5d4f649b58d5d3c9143998366ff6f4c3c486771b5afd4b2beb55de6c68107"
    sha256 cellar: :any_skip_relocation, ventura:       "0016846c6dfc3c43e8a523481d6ae170ee6596412a604efd15b9dd4e52b95728"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba5042dfe207062ca4882c137214959e458f20f9aa8f979af4c56f8fc4852b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a767af0d7914f6450bfcccfc94b2a2bfd68a483ae97b2a8b8867795d0309a2e2"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
