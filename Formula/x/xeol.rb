class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "d26842a3ef75feef22270db4250d16d106e7f9d3ac5f4300ede1b6fc795cdaeb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fd60dffbe50aff6646970d223ca81aba2b061aec6995511701f8b9a0654f88b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7297d56a7e4a4a3ff93405a0ffd722d12431d7dc33f98ed97784ce0a9d26ffcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e8a2c7c38b70743e63d18691075c549c9a4ceae5aa4a05e2ff1354617660301"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef9dccee38ae5c52ffba4bc88d036fa7aa97cd69928ff683947569cef2ff9adf"
    sha256 cellar: :any_skip_relocation, ventura:       "f6e0cd0f03138eb1880f43ada0b2f6ac5f221b4326002ce75c71dd14c023db72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb58a312e8f0dd46954aae799c84df9719970db3a8a39b50815ff4ef38a6fb4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end
