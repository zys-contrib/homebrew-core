class Oranda < Formula
  desc "Generate beautiful landing pages for your developer tools"
  homepage "https://opensource.axo.dev/oranda/"
  url "https://github.com/axodotdev/oranda/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "456baf2b8e36ad6492d5d7a6d2b47b48be87c957db9068500dfd82897462d5bd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/oranda.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"
  depends_on "tailwindcss"

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    ENV["ORANDA_USE_TAILWIND_BINARY"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "oranda #{version}", shell_output("#{bin}/oranda --version")

    system bin/"oranda", "build"
    assert_path_exists testpath/"public/index.html"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"oranda", "serve", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "SUCCESS: Your project is available", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
