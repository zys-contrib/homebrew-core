class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.10/phpstan.phar"
  sha256 "d8e5d7aee69e3092ce6d7e36549cf3af0414baf7c5649030c4bee8df59825b4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75df67d9cc1fe82d0e454f16fa98286d104463c8866f2d700998e0c0cd369c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75df67d9cc1fe82d0e454f16fa98286d104463c8866f2d700998e0c0cd369c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c75df67d9cc1fe82d0e454f16fa98286d104463c8866f2d700998e0c0cd369c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa2f9446a8baf979318c6d9c13ac344d30199afcd03163f07f79812986e3d8d3"
    sha256 cellar: :any_skip_relocation, ventura:       "fa2f9446a8baf979318c6d9c13ac344d30199afcd03163f07f79812986e3d8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e4fccb53870da1d7be5c66e89c42fc0b966ce1d1050194367e697e097f2a13b"
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
