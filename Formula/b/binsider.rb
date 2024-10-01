class Binsider < Formula
  desc "Analyzes ELF binaries"
  homepage "https://binsider.dev/"
  url "https://github.com/orhun/binsider/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "f6792950c77795485414a4e82fce7898debed271a4d6fc6e509dc9bfe7879e72"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/binsider.git", branch: "main"

  depends_on "rust" => :build

  def install
    # We pass this arg to disable the `dynamic-analysis` feature on macOS.
    # This feature is not supported on macOS and fails to compile.
    args = []
    args << "--no-default-features" if OS.mac?

    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/binsider -V")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Invalid Magic Bytes",
      shell_output(bin/"binsider 2>&1", 1)
  end
end
