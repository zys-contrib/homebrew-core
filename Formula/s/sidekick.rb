class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https://github.com/MightyMoud/sidekick"
  url "https://github.com/MightyMoud/sidekick/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "52ae8c36eac8ea0132393b6e1507bd45ac9bc5d4a29891b8f445db8935a3b5c9"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ebaeca180980c3ecc60500d5b95d4d87f6b664d08257ed7b2bdc20a1c001c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ebaeca180980c3ecc60500d5b95d4d87f6b664d08257ed7b2bdc20a1c001c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12ebaeca180980c3ecc60500d5b95d4d87f6b664d08257ed7b2bdc20a1c001c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "921e014e8a8586088042a5b9c9f8023e65c788d9e732475b5b1448394911d010"
    sha256 cellar: :any_skip_relocation, ventura:       "921e014e8a8586088042a5b9c9f8023e65c788d9e732475b5b1448394911d010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0aa9e0d6b5ea8cdceabd3a6f321f14630fc34835ca4cd7be175fbaa0fa6fc71"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin/"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}/sidekick deploy", 1))
  end
end
