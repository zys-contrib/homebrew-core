class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.12.tar.gz"
  sha256 "1630a31cda310cbf80fec1b53eac33b5240c77c149fdb2b3195a2d4915c4cb5e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d480ab40457f17f46138e91078d7fdb4ca6d8d581d51095030adcc9ff3316a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a8187cea8deaa2e1affab988edf483bcad3433006807939c0fcab9d0082215f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac991f8b2085c5c506f909df66909efd443e6799a13cf500e8d8ee5753556144"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebcb771a7dd5bed61b909a018eaaf60325667c8de640da4ac61562a484f63580"
    sha256 cellar: :any_skip_relocation, ventura:        "ec9b2b45a342008e3ba9ee2c712b3ad16affb4433fdfb72eb91cec623f822921"
    sha256 cellar: :any_skip_relocation, monterey:       "d5988584a4bfe0847b274470c3500545733005f0daab3001e12173a0810cb20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24564c1a67082b0b5324517a84d8568bc3f84d7a3af816a3836989e8d98df162"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
