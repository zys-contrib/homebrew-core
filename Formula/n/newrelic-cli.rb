class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.14.tar.gz"
  sha256 "b83e209daf3b106d64fc504e119becb4dfbbf1356fc9c583262bfa871e52dfb1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8ae459b11552c5c03ad2d5ab809754f2096840bb814e275fecaa9329759b470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb38cda61c3341f723844e4cb99033fcba8f079d2b9acd08fcf331fc5a189fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9be61329a159daf63466fbc8b5f21eca990beb9930f50b2240779a0ac29cc88e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ed999b91963ec76d789063e838983c77d409b8068da091d4d4bf869bd3f30eb"
    sha256 cellar: :any_skip_relocation, ventura:       "dc78684ac741a3c42cbaaf1a90d95fce6f1f9fbe0abb8a0de344675f431ac053"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe22608262246915aefbdf8383b6f60710f5afcacd74715aefcaf05ec3f1905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1b1a90318977f67c004a54ca0da9a331e894bb9f8b0c12557c088ebed8dfd5"
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
