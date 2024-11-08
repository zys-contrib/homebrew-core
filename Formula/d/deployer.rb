class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.5/deployer.phar"
  sha256 "30c1c09038b0c390f40d21b3cb0a9e1ff46cfeefe4da1c834aeca6adfb5952d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eae27cf112e397fa3db5b53b0e02f7421a46a5db7eaa420ae634f554bab9ada4"
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
