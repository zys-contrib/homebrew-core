class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.99.2.tar.gz"
  sha256 "082968ff2349a084eb3318d4736dbc06ba10fef7a302a3774297ea88175db74d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc0473706ad735bbfca6547c91894ced92c446cb11b8e9ce327d11885c35239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18c21e03ac9848db0ea82fda8d13c1aad2029ff97da1da7ba383822f5b78d661"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3d64481131e8133486d85816fe08ce674ce0a16aad21935f227bfd85b62075a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c630cd7600516c48a4113086bdc57cd663ac695082681d79fc447c8f87c36d8d"
    sha256 cellar: :any_skip_relocation, ventura:       "e02823994342ca756077129f19b44ac80bc2e95f431ffe5faf4ea5808028e56f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2903599df3914c52ddbbde0ae72c96bfa9ff86eea723e4cf6543a3f79013f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2e1b73f7ce85c337d34e3272e5ac7b176068d3851c70103ddd9a290289faae"
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
