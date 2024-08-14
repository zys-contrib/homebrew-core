class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "fcfe835c5d63a458e59c16d268bc363b22ba48bd3d880a2b141d051021ddd0b2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dec063436b8b9c4c4a97e992bca7be4c90fc16edd9694ebdd9908e9ff500a5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40327d029597648f8f76aaf2791a4c0594446ecbb177327ba9fa31398bc897db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01712de8b6e5bcfff77bee15f1d1444544fa61b9f897ef2abdcb5b3411dfc611"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c80a4cb39aac9d6acc91b3f5e6747fe75f2ae9cf8d29ed1b7f50b60fbf7138e"
    sha256 cellar: :any_skip_relocation, ventura:        "04817d1c0a4ee16e93469233677efb447ad0de3ab80f6728cb1924dcf69a3b63"
    sha256 cellar: :any_skip_relocation, monterey:       "cab61803415e3c145e17e8455f7421233026a33b194209ef65e2462a4322e529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3186fe2214ba3dc7d20eb864a20355cd101a188d2f88f978e70e0129da7529"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "ui/form" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowpipe -v")

    ret_status = OS.mac? ? 1 : 0
    output = shell_output(bin/"flowpipe mod list 2>&1", ret_status)
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end
