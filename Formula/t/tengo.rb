class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "61279c893e0c0d2a02a21c9e724a0124e719798948776e1bac41b7fb845136ae"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91af3b8967466b0287c2cafa9b4ba0450929c3689132301461b38fb8322be785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91af3b8967466b0287c2cafa9b4ba0450929c3689132301461b38fb8322be785"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91af3b8967466b0287c2cafa9b4ba0450929c3689132301461b38fb8322be785"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e07ec75a2de6988bae8ff7333beaed72cbc48c0422b65ba709a3f292ee3598e"
    sha256 cellar: :any_skip_relocation, ventura:       "7e07ec75a2de6988bae8ff7333beaed72cbc48c0422b65ba709a3f292ee3598e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94aaef6daa7d56e4096ca3a88bda5cc573559443fa9ef8e8b96ae997837bd79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdac2cc3ac55ebd2ffe8e2298e75a17866d05dc7f093b1393378b2b963eaaaa8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tengo"
  end

  test do
    (testpath/"main.tengo").write <<~EOS
      fmt := import("fmt")

      each := func(seq, fn) {
          for x in seq { fn(x) }
      }

      sum := func(init, seq) {
          each(seq, func(x) { init += x })
          return init
      }

      fmt.println(sum(0, [1, 2, 3]))   // "6"
      fmt.println(sum("", [1, 2, 3]))  // "123"
    EOS
    assert_equal "6\n123\n", shell_output("#{bin}/tengo #{testpath}/main.tengo")
  end
end
