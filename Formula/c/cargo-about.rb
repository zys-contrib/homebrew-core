class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.6.4.tar.gz"
  sha256 "94a3cd55e82fc8adf99d49e311011a5a9a0fb5e152a45fe42af42897c451484c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3610cbbb0e595227084abb9fad1b708b06781b35b7375b71e0218d5b7eec7d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d05f4795d28210233c8d6da3188411fbe178d2ae67e0e6b948d8c83dd8764b58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33a1dc521e2238fd5f711fd1d2d12505af5f0f938fe6b3ceda251eed44e60e6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "561be92c7f22e3e986dc95fb14180a3ad53dc58933d20669d9c040d965a55055"
    sha256 cellar: :any_skip_relocation, ventura:        "f1e51d9358d1cb427da9faabfe65b805e819ab4c6a5e0d5d89042a1137f24f08"
    sha256 cellar: :any_skip_relocation, monterey:       "1c2c04df8a6ecde5c3e7ebdacb1234ebfe4191e818d603f69623ac510024837f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae47754d95d4ec98e8d0161a7a3a7d8c091da16674cac6f33cf0f4f59feab07c"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      system bin/"cargo-about", "init"
      assert_predicate crate/"about.hbs", :exist?

      expected = <<~EOS
        accepted = [
            "Apache-2.0",
            "MIT",
        ]
      EOS
      assert_equal expected, (crate/"about.toml").read

      output = shell_output("cargo about generate about.hbs")
      assert_match "The above copyright notice and this permission notice", output
    end
  end
end
