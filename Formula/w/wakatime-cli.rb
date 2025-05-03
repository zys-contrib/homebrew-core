class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.115.2",
      revision: "58d267621ce91a5d0e31917fcccec5ea4e3ca07b"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26869f680935afba78ba3c7cffd126138794bbf13911e0743bbb1816986d1bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26869f680935afba78ba3c7cffd126138794bbf13911e0743bbb1816986d1bf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26869f680935afba78ba3c7cffd126138794bbf13911e0743bbb1816986d1bf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8887e0a47844b7fce8a8ac07d5d4c8d1d0a77dee176db39ff9a606373d66f3ad"
    sha256 cellar: :any_skip_relocation, ventura:       "8887e0a47844b7fce8a8ac07d5d4c8d1d0a77dee176db39ff9a606373d66f3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95b43d649cfcfed0a006cde4a51d2befe62b0cf0b1f5e670515b403779a1e83"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
