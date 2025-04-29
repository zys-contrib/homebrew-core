class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/1.1.1.tar.gz"
  sha256 "8fe84708dc14b452de060449aaf550cda922a862b4e3bb05ad971faf92f92f77"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a52af9e111a038ef0e7aa6a877ea8a56d9a870b62e86d2416bc38895016b5714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273834d4e42f43062d4cf5b969ecba96bb7a0d5f241fe5a554c62c07e8434a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2f80c9457e4be9642728801eac6ed6c1b198ecbe8c8c416cc9ee25635084899"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a70a99db98dfed54d3dd1990f3527923c5f321b3142674a434e02a35f36d860"
    sha256 cellar: :any_skip_relocation, ventura:       "84e2e714c6fad4f32f13b0150a94a46a2d070a4a062a85baf39b9ffb50cd4e53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acc18a8a67e9a98d77d75549913e4a7b59cdfac7ba29390a87b56e25f8c286e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c1ebbfbe139a36b26e3ffd45e032b2b8198a2f8af80b73c619059ebe6b79e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>404 Not Found</title>
      </head>
      <body>
          <h1>404 Not Found</h1>
          <p>The requested resource wasn't found. Double-check the URL if entered manually.</p>
      </body>
      </html>
    HTML

    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
