class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "db0af1b8969e307a531b362039fbfb030a568de17763a6825195d958c73352bb"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e2f511e5ccecf0b60aeb7e486679d1537a5820576edade43c1bc890994a668c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e2f511e5ccecf0b60aeb7e486679d1537a5820576edade43c1bc890994a668c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e2f511e5ccecf0b60aeb7e486679d1537a5820576edade43c1bc890994a668c"
    sha256 cellar: :any_skip_relocation, sonoma:        "655da2d18fef74606659e8ae5d85498aa02be42e9cc0183aba14af1ec22115e5"
    sha256 cellar: :any_skip_relocation, ventura:       "655da2d18fef74606659e8ae5d85498aa02be42e9cc0183aba14af1ec22115e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2c14fe47f1fffb75284b2ef2ae8e09f3c9f4c334ea9de2a59c7413caafbc65b"
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
