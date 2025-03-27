class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.11.tar.gz"
  sha256 "ce6a4baf16f2ce9f738312392ddd4f751e9d76ad646e92052720e807e4bd3970"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d33e2b14759b44bb3babaa8d405ddb4c742af080e0a766ecb4596a3ef23440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1232263623291e4caf55a37752707bbaf1d49d37fa491efa415083721cdd20db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faca30935470a29f37b9f79d6b6d1b9f4db936e01c2fb432f72bc26dc7dd9e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca31b7ae402a2d5b858b84affada5e25584aa673d5b280c4047f8178002d2806"
    sha256 cellar: :any_skip_relocation, ventura:       "a434191351050daf1e6d5043953fbddd8340e6323b1bea5e46afad0ac9408a13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f07e17b1243c8d301fc1060f92c715190198b6ab1b5b185b2159e380e21c7d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d60fd83793c1302c267cf840fda84889a90932e31a5fa93877d6fcd5f13033"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath/"Trunk.toml"
    (testpath/"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end
