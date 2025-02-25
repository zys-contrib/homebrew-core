class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.8.8/psalm.phar"
  sha256 "eeb7a8fcb808747709ab0ae1c1e8419be101226f50d999f72cabf09efd9ac7ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b57f914a40489e2730aac7e5c6edb5ca5f6db8b4f05c312403c3d1a0fdd52a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b57f914a40489e2730aac7e5c6edb5ca5f6db8b4f05c312403c3d1a0fdd52a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b57f914a40489e2730aac7e5c6edb5ca5f6db8b4f05c312403c3d1a0fdd52a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2884455eeea99dab568766c6b45995883c6255fba794e5b171af46f06514ce7"
    sha256 cellar: :any_skip_relocation, ventura:       "a2884455eeea99dab568766c6b45995883c6255fba794e5b171af46f06514ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b57f914a40489e2730aac7e5c6edb5ca5f6db8b4f05c312403c3d1a0fdd52a1"
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
