class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.4 on the next release, if possible.
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.68.0/php-cs-fixer.phar"
  sha256 "75ccdf17d43c8d924a3714e4ff5f8274a651683d41e62dac15a34b0fcc9efaa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d2d4c4072328938f0c30f915fe36ac171670fa3e9467683871745ee20fcfeba"
  end

  depends_on "php@8.3" # php 8.4 support milestone, https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/milestone/173

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~PHP
      #!#{Formula["php@8.3"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    PHP
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
