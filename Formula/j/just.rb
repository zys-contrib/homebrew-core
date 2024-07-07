class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.30.1.tar.gz"
  sha256 "bc63b5fce7b1805af4e9381fe73ab1e4a8eba6591d9da4251500dfce383e48ba"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2902c8556b74f29a6543b4937c874e15ff0b88f8fbc6c6ae4672eb05b81859b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "941fec550425f25b4e5c4cb79eb4f33aecf09c137504c8f5170922190912f1f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4dfaf2d8dc0a888723aec621361b449a7c369cb572d8024fa49e1c8cefdef5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "66e99a9eb55e40e007990f285bdaa99037b9a114cc4d08c8f2a1e8d4eee95b07"
    sha256 cellar: :any_skip_relocation, ventura:        "5a7c57540963af859f6b41fe660524394c02f7474cbf1bb344825cda27e40263"
    sha256 cellar: :any_skip_relocation, monterey:       "110a5be4f358627e2812081d5bdfb71a1767c2770aafe979c726fd73a169ade2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06c179c41e8a48ef6a76a3a1c5a520065e16567357a30fa1e1a80cf714d43b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
