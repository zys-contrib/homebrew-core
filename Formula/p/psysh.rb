class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.6/psysh-v0.12.6.tar.gz"
  sha256 "f5aeaf905ca7721bac1b710d9554b67ef48d10dc11156b218042b0200ce6be33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1432334912261eef9739f87bdc14b4e83ad7486de1b21805fcbeab8d70172c"
    sha256 cellar: :any_skip_relocation, ventura:       "5c1432334912261eef9739f87bdc14b4e83ad7486de1b21805fcbeab8d70172c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7abb6a8e64bcac85e0c8553ad0ec240b1fef900839aebbd1b7b0888cc3c2c7f3"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
