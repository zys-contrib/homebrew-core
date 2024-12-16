class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "b445c5dcff98e327507114c6a6dbeda6fc738cacb53dbb4d1c713728985f6b2a"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08c6e0d781334403eb935a2544b325c13b620af2b8943066f4e5b3b61ff1c9dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1c090ebaa097b4cb5a71b9ff4416a3c91dc4df5ddad5b2f7478d3ed1070031e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d6aedaa18c912283325a140a81797f36d6555db45aeac18d83817445b1fb081"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3b7179883aa16c10609d8fed826ca44284baaa1d11d3e90a9240367cdb983d"
    sha256 cellar: :any_skip_relocation, ventura:       "6063dd4599f64447a16ac83fb7a89b06e0697a7b5f9adddaf817542e2813be93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650b22e942dcf7f05140613ad430a7907e8143f37036ef6d9121220d4cb43f13"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end
