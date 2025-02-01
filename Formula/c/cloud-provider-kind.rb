class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ba3fad794370b1ff14e608edfa5883cb455e1e6e89d6a63187c5f47bf4e23251"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 255)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "can not detect cluster provider", status_output
    end
  end
end
