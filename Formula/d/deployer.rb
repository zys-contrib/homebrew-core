class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.8/deployer.phar"
  sha256 "72bc7b3508a7877b7b4fe3877de72738ff28b512a056ccfbcc432d0baf325ec6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2395a4ddafeba7594d99b6a9cc6555da0b126d2d49fb0ed928b457d55c9d7d3"
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
