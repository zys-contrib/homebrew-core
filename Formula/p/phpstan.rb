class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.2/phpstan.phar"
  sha256 "2c51773761fedf0d1a2be6dded91f02b49817f2963ae8690b273939dd2cdb1db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb5503742637c4802387f06d2a3e8c56b83716187a254911d05b5f299241fc1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb5503742637c4802387f06d2a3e8c56b83716187a254911d05b5f299241fc1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5503742637c4802387f06d2a3e8c56b83716187a254911d05b5f299241fc1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a80054aecce88d4d125f834c73fdbd50e3bfdc1d4229c7cccdda34fdf9ca2a"
    sha256 cellar: :any_skip_relocation, ventura:       "28a80054aecce88d4d125f834c73fdbd50e3bfdc1d4229c7cccdda34fdf9ca2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b218fa05af8aea7fd540d71d1fb35a781a5f0049ea45df375c5f7685d66bf540"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~PHP
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    PHP

    (testpath/"src/Email.php").write <<~PHP
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
