class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.9.4/psalm.phar"
  sha256 "940841e3821416ad20eadee09d765230809b9a69d349758d73dae70085ddc785"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2007f5f2ab3c1b545ba8beaa3f148e3e35de9ced42ab4a6eb025290d5b2f1d10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2007f5f2ab3c1b545ba8beaa3f148e3e35de9ced42ab4a6eb025290d5b2f1d10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2007f5f2ab3c1b545ba8beaa3f148e3e35de9ced42ab4a6eb025290d5b2f1d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "822c774b3552858e41f8df74e7e74bc52487b6f5c629dd2a3eb3158aacd214c0"
    sha256 cellar: :any_skip_relocation, ventura:       "822c774b3552858e41f8df74e7e74bc52487b6f5c629dd2a3eb3158aacd214c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2007f5f2ab3c1b545ba8beaa3f148e3e35de9ced42ab4a6eb025290d5b2f1d10"
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
