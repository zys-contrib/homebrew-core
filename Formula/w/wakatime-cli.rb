class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.92.0",
    revision: "6d44bd8f1b2d7805ba36b2ead1ee12321752ced4"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b6db4221cd2c6e8ef8d8d1892a8b06906d931ef8ab66cb1915582fd06cc4f93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b589a9356396e9654524f7e5c361a91c7ad13b7c3c8f42b6a94c1d4ccf8573f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821aec0a3fa01905007b2580f8895db0526c75007e263a42d0d1f73b303e3d7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8befeddf5ec251fc8e9bd553e8c540fb4059e10cd54e4346bda4db65fe69d903"
    sha256 cellar: :any_skip_relocation, ventura:        "f846c79327ae7432d60711bfecbb944da90a76b44550575edd81f32d7a0c1727"
    sha256 cellar: :any_skip_relocation, monterey:       "66f4f9e540f94710d9f8292c2e4ab856be90f8b9e5a6efdacc296fa75adf3116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c062bcfd21ca80db7dd4f0a663765c7ba705ab8cd0aad4d56728e06fe5334903"
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
