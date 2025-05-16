class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.15/phpstan.phar"
  sha256 "700a262eb939c6fc81497971d9f08e77219147a570446d629bef833b7e9b93f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c389aab71e0bec1dd0c5f41a9a2744d38dba4477028547eed9631c348c66fc2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c389aab71e0bec1dd0c5f41a9a2744d38dba4477028547eed9631c348c66fc2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c389aab71e0bec1dd0c5f41a9a2744d38dba4477028547eed9631c348c66fc2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b32e72c085b05ea700867013b02bff7865ecce63e25e130ec4dfbc30917036bc"
    sha256 cellar: :any_skip_relocation, ventura:       "b32e72c085b05ea700867013b02bff7865ecce63e25e130ec4dfbc30917036bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e443af05653b01e5c4ce408780d132367e20a8fade3c0f79d4af39b14bb55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60e443af05653b01e5c4ce408780d132367e20a8fade3c0f79d4af39b14bb55b"
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
