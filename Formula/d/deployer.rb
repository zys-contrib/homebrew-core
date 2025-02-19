class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.12/deployer.phar"
  sha256 "b55c6609653e888c672d327c407f8bba6324b9c9cc24f9dcfb3f4b3922760632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2936d207c8a49609aeb7b63861cd103c9d05929562e6807c8452072f589ad2d"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_path_exists testpath/"deploy.php"
  end
end
