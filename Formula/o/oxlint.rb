class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.5.0.tar.gz"
  sha256 "a1a8d0910ff0ad51e505c6c3f2b85e23a868b311a6f90bd3116b7be860d284f0"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200f1a0d54821ccbeed3aed5c8e3a9a7e830ce854f461332ca5ddb9ca5c50a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f11e1304fdacfff6c629688e06d95b481a0f6a9ded04985bbd1daa166513df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f743d4acc94792d76426d817ab49abbe9e328c45c40578c4b265a8b9a9f2fa0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a0a5b5cdf31edb2da10576a5f770f4efa0939e08c5e0ea181d187e27567bec8"
    sha256 cellar: :any_skip_relocation, ventura:       "c63688a1fcb4cbb3d8135fbaf567e09c564c7eebb65b6736325a5fa73be84f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53754260dc96a55bfee776f9b7371df34c4240d3a81a35c0f41a9070e80a85aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e43659c3e8bc8c6a4bd82640b153154ce83e8dae06d0c43cdec82ce0ef10b55"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
