class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "786c1b7555c1f9562d7eb3994d932445ab869791be65bc77b8bd1fbbae3890b8"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d24e8e746b554047afae26ffe5c263095e18162ca461c77805b8c7ea1b66f338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9cbb8da1f4eaf4c059803b870f39ef7d632a10dce9f152c0388513124f9a3e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e48364535dee58682e1eca9fcaa07bebb9be981436f544682df8ba332d91de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c84d3c02830f60ee6fe1f19633bac46dd586fbf07607072ece33b1f609f1a48"
    sha256 cellar: :any_skip_relocation, ventura:       "b386766395ed06b864e9970e5aa91b7bcb0f7e4027625b5bc39361e443780fa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13826ae579b577c0dd07859560cb507a1417827395df93838902af32c451f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0ae451a6744962ab29372dbbfe142bd603cfc5e2bcac090c2dbd027a3bca74"
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
