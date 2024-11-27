class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.7/deployer.phar"
  sha256 "f8ea30da7ce6cc520924236e8461e8802221cc566c96f6b310bc0af6e8e85e2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0525fd0dd685a00f848dacc06b9608c7ce0a1aa3d4b1633295d9de1b28a6ebbd"
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
