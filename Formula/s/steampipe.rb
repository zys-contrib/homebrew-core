class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "d9ef636ac596930fe88741fd3e9703df802409f17e6e2ee31648f075590d0f46"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b57231af1b7d8b8660c7e91ea97b2a327fc480a679c0a47a48459168a7ee11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2641c831c3019a4a66ec89549665462951844c3764eb152b30d8636bb6229a5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d34cfe8e39e3f23a31ee54afadbdf91a31624a443ff2590c74372a0ddebe49f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6d5eb17e7c6897f3cce3a315af24a42701cbceb9d599f6cfccdaf94b6738d54"
    sha256 cellar: :any_skip_relocation, ventura:       "c98e6d7a849d81e26c3ed222827319c865c3a8a7872b29d0ce39b20f7eee7ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d537ab1f891cec172b266aaf26a9e1432d58f6df26431e7691a42ee277db7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
