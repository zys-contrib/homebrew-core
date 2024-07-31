class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "ce52b5a85dd47752d317bb19a2402c1ac98099c57f0c5c09b1c652bc63a1217f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57c2fa997194c95e414d0d4de4f621b55f93c98e339fa036e9896893f7ce9469"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2435dcb6d78eb171a50f1f51b6478ea26ac74010a1a772a1fa205b92409ebd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "245cdd7bc98f358570fd13cf81bc0fc682107b6535157920ac904191cc466ae8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3fe97f53fe58a565e1069a0917f6cb3c52a70f054deb4247c1ff4c1237bdb28"
    sha256 cellar: :any_skip_relocation, ventura:        "8864307ab04fd3940b6af352f600a105285e5fa46851f8f69aa8ad4ead348eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "9c933d9a9a35db1b389ab1a5df167ce6564976cd3bbac4fa7efaaf6821a5119e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f42d8bf030a2669b6ddb20fdbd5b94ffd7ce8ef08254d30ec7376aace24bba"
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
