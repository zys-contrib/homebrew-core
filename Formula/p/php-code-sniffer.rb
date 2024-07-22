class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.10.2/phpcs.phar"
  sha256 "5f580b08328af20a4138a6dcefdbb4c3307e133d9dfbabdf925c08c7d87f18de"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2bd0e30c9e5516e76aafdfa4b71ca44ef23e6722b0407cf41e0d559653b019b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a0c74b70622527afa5915133073577597d5ac6551c4fff7b0d908c80bce5969"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fffa1a2a53c59758986777968ab8848605a692856c34008694d7180b4cde1eb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "173c759de0133cf7997863f35b126cadf18f6ba08ad3118c428319fa71c53043"
    sha256 cellar: :any_skip_relocation, ventura:        "4c355847ef5448a3b597646ef9a1458bc6736a2a15c1087263676f2a979164ce"
    sha256 cellar: :any_skip_relocation, monterey:       "d44ff452131376e8eb8086f2ec7d5b34e96cead7908bb449dd949132b5b6432c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c767b4df265c21a1a4ccb607838737b374bef4d0eb972dd61c8dc7d8487e328e"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.10.2/phpcbf.phar"
    sha256 "7b4b1316ce388600c2a052b41b9badd2d906827f0a08a08873ca5d1063dd1038"
  end

  def install
    odie "phpcbf.phar resource needs to be updated" if version != resource("phpcbf.phar").version

    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php
      /**
      * PHP version 5
      *
      * @category  Homebrew
      * @package   Homebrew_Test
      * @author    Homebrew <do.not@email.me>
      * @license   BSD Licence
      * @link      https://brew.sh/
      */
    EOS

    assert_match "FOUND 13 ERRORS", shell_output("#{bin}/phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "13 ERRORS WERE FIXED", shell_output("#{bin}/phpcbf test.php", 1)
    system "#{bin}/phpcs", "test.php"
  end
end
