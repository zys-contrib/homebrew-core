class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "b6937b4ce7a9420919e700d071943b698d1e5b1b1a57fa894f17076d21264da1"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aeeaed3b94381e9ccb89229cdd4359ae797e7397fde5aaaa80382ebae652560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aeeaed3b94381e9ccb89229cdd4359ae797e7397fde5aaaa80382ebae652560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aeeaed3b94381e9ccb89229cdd4359ae797e7397fde5aaaa80382ebae652560"
    sha256 cellar: :any_skip_relocation, sonoma:        "d94a4dbaa4a19285d85caaa1634822172073cebfb1cb158f0b864d0c5bcad1f3"
    sha256 cellar: :any_skip_relocation, ventura:       "d94a4dbaa4a19285d85caaa1634822172073cebfb1cb158f0b864d0c5bcad1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da3e3a7346169ec244452b7286457e9354c2e6d324f29de3f068d067943e1c1"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xk6"
  end

  test do
    str_build = shell_output("#{bin}/xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end
