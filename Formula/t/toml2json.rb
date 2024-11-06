class Toml2json < Formula
  desc "Convert TOML to JSON"
  homepage "https://github.com/woodruffw/toml2json"
  url "https://github.com/woodruffw/toml2json/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d32aceb8387553a25bec45747cdb45ce6a079935a03eb13d3477f68cc1fecaaa"
  license "MIT"
  head "https://github.com/woodruffw/toml2json.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    out = pipe_output(bin/"toml2json", 'wow = "amazing"')
    json = JSON.parse(out)
    assert_equal "amazing", json.fetch("wow")
  end
end
