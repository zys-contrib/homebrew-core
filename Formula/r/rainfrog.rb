class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "e45c13452026d9fe2f5b5db58053704e2c6846b1d9fe182c0b70a296f09b9dba"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "704a9262920791dc7b2002ac44af0e15a62710c79a502ade77b4f8ff6588858f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1802764d441a8b6cc15219f590a436ef3cf93b52aead69a447a10d1e1833f9c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff2b0377629931505f937f7d99c4f5f706237d54644d28dc0ab88e429740d374"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebe1cd3a0835dc08a93668011ae4103bf0ad887f3497ce9b2edcb4d4d5399076"
    sha256 cellar: :any_skip_relocation, ventura:       "903fe1ccf4e162f1052c7496d7e3f8099cabd4aa6647cb24bdf0e36cee92e6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3354e05c7900f3ef5f3b25fa9b74390a59ae7e5308c1d2ad1f568cbcd966fe93"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
