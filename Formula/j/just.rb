class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.29.1.tar.gz"
  sha256 "3e909245038295b6935448d48bb93418b4bc1b0b5621116d1568e12dd872512b"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72f363051f5ca1076973cdd99b8088577dab0876e72a146f272ab637bf754707"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6854b625a6e942fb117a70661c664d265e03c6d85f3b77a1137e1e0faaee30e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81f5facb494286c679b11cb1fc94a0f7d90d3184bdb57ced6b7e4e5319d13a73"
    sha256 cellar: :any_skip_relocation, sonoma:         "d42266215a12f8139c3b5a0fdae14633eef293e4098aaf868e8ffaf0ef7a48e6"
    sha256 cellar: :any_skip_relocation, ventura:        "d4db37ff2d2abf70cc236b8caebad21a0f53c7cf6efdf61880ae22912a3de397"
    sha256 cellar: :any_skip_relocation, monterey:       "48c32e9894cacb5d30744c370ab1d8c6e80fd0aebee43db4e2bbf2b2f6260734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9037873ff7aab68c16ab8fca393e249f47b952110c00408ce29db1240b29785"
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
