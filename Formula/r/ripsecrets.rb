class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "d230246a517f2c4cc9e719633b5c2fe771d7251bac25257f3b927e14fc408071"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba853f83dde44a9483c4554889ead1de75c52ee339dc5796909857754597c748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "216528d31c239eade91c680af65d4bdce83e0eaeb54eb19c5e901d6396c9e186"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38d98aaf362d5f18351a65963c7285df501f7a9968d9b3dd83c26d965088e756"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9acbf3dac2fdb2b49bd5c73bc96758d67c27a77d2c76e1e0ff3b77de23e12fa"
    sha256 cellar: :any_skip_relocation, ventura:       "fc12cbfb7110bf63a098b56bc9f1688383a2d8395574abf2299f144a58f64bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e139c503fdf30535fb46fec7b36d9883d1fa04319d89af5bc3f9a1ea6daf5574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9391621360399a4d739cbdc7966ff5d87e13c0cc5aaa4266dff3319b79b4c3e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Dir["target/release/build/ripsecrets-*/out"].first
    bash_completion.install "#{out_dir}/ripsecrets.bash" => "ripsecrets"
    fish_completion.install "#{out_dir}/ripsecrets.fish"
    zsh_completion.install "#{out_dir}/_ripsecrets"
    man1.install "#{out_dir}/ripsecrets.1"
  end

  test do
    # Generate a real-looking key
    keyspace = "A".upto("Z").to_a + "a".upto("z").to_a + "0".upto("9").to_a + ["_"]
    fake_key = Array.new(36).map { keyspace.sample }
    # but mark it as allowed to test more of the program
    (testpath/"test.txt").write("ghp_#{fake_key.join} # pragma: allowlist secret")

    system bin/"ripsecrets", (testpath/"test.txt")
  end
end
