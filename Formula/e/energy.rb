class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "693ab9fa18633eb7e35089588eb58eb49c9db7886ef175b534aa1ab26862a57c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e62fc9c1a6c58038226e028cd688ef3b2f21b49fe156a13f51f30522348c7951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62fc9c1a6c58038226e028cd688ef3b2f21b49fe156a13f51f30522348c7951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e62fc9c1a6c58038226e028cd688ef3b2f21b49fe156a13f51f30522348c7951"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b3fc139d84fe21b1903ba4e9ce42fb1232572652856e7d91a89797ee5c9840b"
    sha256 cellar: :any_skip_relocation, ventura:       "4b3fc139d84fe21b1903ba4e9ce42fb1232572652856e7d91a89797ee5c9840b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31a37661e5c5249d609858447268f60937b41975741247c43c0c6e322bdced8"
  end

  depends_on "go" => :build

  def install
    cd "cmd/energy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/energy cli -v")
    assert_match "CLI Current: v#{version}", output
    assert_match "CLI Latest : v#{version}", output

    assert_match "https://energy.yanghy.cn", shell_output("#{bin}/energy env")
  end
end
