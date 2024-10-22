class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.3/deployer.phar"
  sha256 "8f60af206016a42b1d9860b81b537a445863d2b1bddd436d5e70c931645484a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63e0d349e8eed0a9292d580bbba7dba6208dacf6685b06492c7b0529139e7418"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
