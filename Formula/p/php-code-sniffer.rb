class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.11.3/phpcs.phar"
  sha256 "f043b299b6f3aa1a8b78cb47848cee28cdc524f31ceff6b24ff70eaf8bf39936"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0a8f50fbca7b6dd6e0b044cdb31a194ca87e3e08680eaa287bf7258b838d3521"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.11.3/phpcbf.phar"
    sha256 "a5c9a212e771b5f5f82e8213467ad35674e8a25cbf84ae88b6b8dd659a749f7c"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "phpcbf.phar resource needs to be updated" if version != resource("phpcbf.phar").version

    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath/"test.php").write <<~PHP
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
    PHP

    assert_match "FOUND 13 ERRORS", shell_output("#{bin}/phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "13 ERRORS WERE FIXED", shell_output("#{bin}/phpcbf test.php", 1)
    system bin/"phpcs", "test.php"
  end
end
