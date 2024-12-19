class JwtCli < Formula
  desc "Super fast CLI tool to decode and encode JWTs built in Rust"
  homepage "https://github.com/mike-engel/jwt-cli"
  url "https://github.com/mike-engel/jwt-cli/archive/refs/tags/6.2.0.tar.gz"
  sha256 "49d67d920391978684dc32b75e553a2abbd46c775365c0fb4b232d22c0ed653a"
  license "MIT"
  head "https://github.com/mike-engel/jwt-cli.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jwt", "completion", base_name: "jwt")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jwt --version")

    encoded = shell_output("#{bin}/jwt encode --secret 'test' '{\"sub\":\"1234567890\"}'").strip
    decoded = shell_output("#{bin}/jwt decode --secret 'test' --ignore-exp '#{encoded}'")
    assert_match '"sub": "1234567890"', decoded
  end
end
