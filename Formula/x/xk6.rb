class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "35a7fa8e059caf7848a67d7dd271f754ef06cf52512b08da1134971b39004900"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xk6"
  end

  test do
    str_build = shell_output("#{bin}/xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end
