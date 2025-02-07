class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.4.1/psalm.phar"
  sha256 "0e4649aa41b70bb7b943efe941e2352703066df4d20d7be44cc66d47d845889d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "783c017caf681733724b9f2d93e17d31df8509732af8673b4ce2bfd1cee3934d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783c017caf681733724b9f2d93e17d31df8509732af8673b4ce2bfd1cee3934d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "783c017caf681733724b9f2d93e17d31df8509732af8673b4ce2bfd1cee3934d"
    sha256 cellar: :any_skip_relocation, sonoma:        "63fc36bb4e2da5036909cc1ae1773c5c49cca6c8d2c99eca27573688fa9077cc"
    sha256 cellar: :any_skip_relocation, ventura:       "63fc36bb4e2da5036909cc1ae1773c5c49cca6c8d2c99eca27573688fa9077cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "783c017caf681733724b9f2d93e17d31df8509732af8673b4ce2bfd1cee3934d"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    libexec.install "psalm.phar" => "psalm"

    (bin/"psalm").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/psalm';
    EOS
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/psalm-test",
        "description": "Testing if Psalm has been installed properly.",
        "type": "project",
        "require": {
          "php": ">=8.1"
        },
        "license": "MIT",
        "autoload": {
          "psr-4": {
            "Homebrew\\\\PsalmTest\\\\": "src/"
          }
        },
        "minimum-stability": "stable"
      }
    JSON

    (testpath/"src/Email.php").write <<~PHP
      <?php
      declare(strict_types=1);

      namespace Homebrew\\PsalmTest;

      final class Email
      {
        private string $email;

        private function __construct(string $email)
        {
          $this->ensureIsValidEmail($email);

          $this->email = $email;
        }

        /**
        * @psalm-suppress PossiblyUnusedMethod
        */
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
            throw new \\InvalidArgumentException(
              sprintf(
                '"%s" is not a valid email address',
                $email
              )
            );
          }
        }
      }
    PHP

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}/psalm --init")
    system bin/"psalm", "--no-progress"
  end
end
