class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.10",
      revision: "f7310370514b5b8af3deb750636cb526532488e5"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2de2248f230c79ca8b8d84cab089de405519197c51f605c01d8e5ae72a21748d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2de2248f230c79ca8b8d84cab089de405519197c51f605c01d8e5ae72a21748d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2de2248f230c79ca8b8d84cab089de405519197c51f605c01d8e5ae72a21748d"
    sha256 cellar: :any_skip_relocation, sonoma:         "33347b243c121aa11bcd24ca867782fb2276217cd41400b8e4716be6d0a48e8a"
    sha256 cellar: :any_skip_relocation, ventura:        "33347b243c121aa11bcd24ca867782fb2276217cd41400b8e4716be6d0a48e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "33347b243c121aa11bcd24ca867782fb2276217cd41400b8e4716be6d0a48e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296f2026dfa0ec2353cb35cec290b5b9fc591c737e8cf05d4dc62fedd22302e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_predicate testpath/"server.yml", :exist?
  end
end
