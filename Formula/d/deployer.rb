class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.4/deployer.phar"
  sha256 "22b7d7063429f2714fcb2ef54ef677a2821eb53e9ce37b70f5fbdb937ba653d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29cffc2afb9726fa54f7783888e34451601f801fcdb25312f89f83cd46980f6e"
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
