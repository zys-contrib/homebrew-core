class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.61.1/php-cs-fixer.phar"
  sha256 "a87859b5692fd309e9e2fef70f3766960c5d98331f44905723bb19182b46a902"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df34d46ea96550cfc688106ebe026cc4638c1c522dcdacbb2aa5d635689dfa3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df34d46ea96550cfc688106ebe026cc4638c1c522dcdacbb2aa5d635689dfa3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df34d46ea96550cfc688106ebe026cc4638c1c522dcdacbb2aa5d635689dfa3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "df34d46ea96550cfc688106ebe026cc4638c1c522dcdacbb2aa5d635689dfa3d"
    sha256 cellar: :any_skip_relocation, ventura:        "df34d46ea96550cfc688106ebe026cc4638c1c522dcdacbb2aa5d635689dfa3d"
    sha256 cellar: :any_skip_relocation, monterey:       "df34d46ea96550cfc688106ebe026cc4638c1c522dcdacbb2aa5d635689dfa3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83856b33437a7f017451fd1346366884866dab7175d8209dc19b08329c4a9d9"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
