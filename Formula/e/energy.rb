class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "a643cfe6ccac53c1c71bd1ec6a9e070c1f5f98c86368a70a093ea556806bd3fb"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    cd "cmd/energy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/energy cli -v")
    assert_match "Current", output
    assert_match "Latest", output
    output = shell_output("#{bin}/energy env")
    assert_match "Get ENERGY Framework Development Environment", output
    assert_match "GOROOT", output
    assert_match "ENERGY_HOME", output
  end
end
