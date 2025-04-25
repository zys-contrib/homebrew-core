class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.20.0.tar.gz"
  sha256 "d0e869a6ced81caf36dae0a5084a4ea7f40eca9940c7ce233f34de0761a5f289"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb04dbbdcf92af77766a3296ab763ebe5af483a0fcdbf6e134d71729b1cffa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef10bc7d383e4ce5611cb0a89219acac562c942f67280428aac974c9571c068"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15ed08e1cc5f6aea0d58b32b3403927709dc234c9b5ce1b22327df7400c09e91"
    sha256 cellar: :any_skip_relocation, sonoma:        "66ff4351413ffc52e4a69f29a43b5b9414afc6ef2bd928e68a64b83d617678ae"
    sha256 cellar: :any_skip_relocation, ventura:       "0f7a1cc2dc6228f6fa0962a3370ea5c960ae2a9dec4332687a5118618b5a702a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca98ca5c83d2fd4173b174c55ec93062b24a7f1bdf4b087bf9dc22720eb2909f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d11e26ca7504d6ff591ae93e3b180a0eb9e670ef0a213f2bf5e61850538bdab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
