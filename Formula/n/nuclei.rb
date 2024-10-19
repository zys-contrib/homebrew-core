class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "aafdfd00a65c72bf1414934cc932b262316f167838835e619b7c079db825b569"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35fed127a51af3e3b3627780b0b10efb1c1e65c25e2d8348337737cf856d87d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4bd5f734a0773dda5249857312c75234c6a6613953193dbf40fe1651da2706"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "270243b6e4a5516fb5368319e8226da6ef792cadc22c7e577579b55794fbc114"
    sha256 cellar: :any_skip_relocation, sonoma:        "35908f49887ce4f8489f78e7f195e6a6fad1c4faf3d77db9ffd2a89c6714143a"
    sha256 cellar: :any_skip_relocation, ventura:       "f3a52a145e2ede4cfc64bf364cfb8a5e6cddd1f39ae4438139f76dd3d281fcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b45517fb51fbc1e59940e473aadbf92f02ca6738aa29273c18f019e061c9805"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
