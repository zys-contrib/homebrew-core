class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.1.46.tar.gz"
  sha256 "8189b26f158d30ac09a8855fffa72fbaadbcb777eb3c1fca23e2532f333ba228"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bce45cf8db50e54af85288fe5de380d0a0e42f3fda646eb30fc44b1e1ace844"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~EOS
      [default]
      token = abcd1234
    EOS
    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
