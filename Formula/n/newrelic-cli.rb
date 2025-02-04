class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.5.tar.gz"
  sha256 "2fbf3d8832c0816587b24b22688e9e20962e3f73fc4c476d2081cff24d2a6e94"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad373c8b9c5feea972433c358f03ea5d93f8b73a1bbf5d19fa38c4a868b8b25d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed1ff2eefcce8e66abefa81c74519c9909a50f6d8af630c94d332125b5c1ecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fae45859b81f6b80db3076bd58661fe5320b520efcd6a9685b2579ffdd8edeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c89843964cf24f92308aca6699eedb7539758a766bf445c93ba41462bb6f8fa"
    sha256 cellar: :any_skip_relocation, ventura:       "bb2d21fe4c95ab4a1b9e2aa0fb07f147397f1a6752b5d7a512ff0eb56cf5c2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f5a587a45b798c9f4855d590d5e99609f1c48748337a373f71cc9f4381740e"
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
