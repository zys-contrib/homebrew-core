class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.104.tar.gz"
  sha256 "b7ae9d9446acccdf14adb2d7d0146f17b863121101facfd68f603c29c4442180"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee3990129d757a037152829a090e3579b9f71fe071cda69c7a12c617c1108645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09964858ce9cc9e836b5e9022fbd6a1779bbfe851c2e086df92397aa07e05689"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28a11090a5e2b814e9aceb87c9a9955f61e153a76c1c47193f372dcff6234ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b8b52f7e30ce27c796f824a90434baa3e38174cd7bcc85dea10bd07d676a770"
    sha256 cellar: :any_skip_relocation, ventura:       "5b78196528e1ff81ece9e90ffc88a4def945025e8adc938f7516fafe9f1080e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "610478839b867697ac953d58a81d8b5c0b635bb7ea5d7e9a6b5595edabafd797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789069f3518a26efd6a3af93b817d6fcce1e610c6fb543bc6334a7fbb2510ec8"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end
