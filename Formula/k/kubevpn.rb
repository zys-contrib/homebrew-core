class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "2ebd97ff789de7f36ade5f94cf19ce279f69c878f75023b3140e3a3f7c2bb2c5"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8ec99bc9ec08db1a47189e42804c1668ea580a8bd08f2f8668b8cbdf904971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06eec4649c4394ea19f5ab6e02421da5379a3880221eec99cf81d45259cf6339"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2969c91c91855aedc0702013313ae7175129f3aa8bafc638fd0827209d7a8e61"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bb605f7b782e3e4288f1d47d2d5c1f63ffd9fa1597271f0ba7ff5f0f3035811"
    sha256 cellar: :any_skip_relocation, ventura:       "bd0a4f2d0fc9b0e3d3441110c6f709dd14a0cdd34c5b761d310f6c784c25aca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc7a955c948d25ee7773eb65a64537977329a044e8e8287417e6ce18cebbebcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5ea549b4af4badbff942e841c9d8c2443e14cf7452b02f665dc8c44f9374945"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    tags = "noassets"
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=ghcr.io/kubenetworks/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=brew
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end
