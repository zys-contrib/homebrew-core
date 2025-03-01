class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "7716275d2347d67a8dbbaeb0181ae32c544d349984aced0dea3b3d45048fb6ff"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33b15c2e57b50b0d448f42a1b7f50325b703ef9e84e51b35cf5a2d749ab1e0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6851255a91cc6033662553af683a9bba2fc7525b0e0ec1ba444e63e2defc8966"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3450a4424d05300a4c35c62da22012618b487ac86d7bbb03e73c5d5fec239c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa22997c67a29ce1b493f5279cf7a638f77ddba317562bd6e8ce8caedcf3ad3"
    sha256 cellar: :any_skip_relocation, ventura:       "8aa22997c67a29ce1b493f5279cf7a638f77ddba317562bd6e8ce8caedcf3ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa3ece379e8bb79962a07db68f9c8116a36ce8132f7d11bb419f8995c905ae0c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/OpenIoTHub/gateway-go/info.Version=#{version}
      -X github.com/OpenIoTHub/gateway-go/info.Commit=
      -X github.com/OpenIoTHub/gateway-go/info.Date=#{Time.now.iso8601}
      -X github.com/OpenIoTHub/gateway-go/info.BuiltBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
    (etc/"gateway-go").install "gateway-go.yaml"
  end

  service do
    run [opt_bin/"gateway-go", "-c", etc/"gateway-go.yaml"]
    keep_alive true
    error_log_path var/"log/gateway-go.log"
    log_path var/"log/gateway-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_path_exists testpath/"gateway.yml"
  end
end
