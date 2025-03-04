class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "9dd58cd426a482dec174e894303a483b970aeb9a04a948cc5d853db49895f400"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8a9ac5fa2720e75e0d427f95527bbfb858f2a7abde8feb9772cdd0a39c18087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8522043fe0480df85dd776c8ce0da2450daebbebec91a7effa8d4bae6f58c9db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05d962030e3598aa428c0ec00d8866c2974bc7f81891b01764ea502994fd12ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4927e1da9969e40ac061e2e5048702bf09ed38a39b18be2d8b825c13fb0807"
    sha256 cellar: :any_skip_relocation, ventura:       "bf1541d210715624ff744e5f788efb316e93e9943570b9158494f6ad2f4ad226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31e1d3b9625c92a69aa0c7e2c1e9af853dfc79428f81ee2a0b8899b021e03b19"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
