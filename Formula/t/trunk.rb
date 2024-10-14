class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "648ff0f89fe461d4977f389e38c5780cd79762ff5caf81e610c37461ea4801d9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b82cde9a326c740d8f9618216ead5bd2451f493f163cf9dbecabc191a9fbfe1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "225960f46ef7bb1fd7fc1cadc4acbc5d28c63b464787f915d1412a8ed1c90063"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecf10a431d211be0fd580ecbe04d01e4905f6bbf70c9184a90b5b9371ee32d03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f40dbc5c8b598a82ac412392d1c82c44f62d3bb2dba3c2af45bfe35957939fc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ebe24c4876cc64c3058da67a916676bd665d98b7fad334950a37422989f0597"
    sha256 cellar: :any_skip_relocation, ventura:        "2bad73afc354e3b2efbb6aaf9f5c197417be456b1a9d659ca12ea3195ef5f421"
    sha256 cellar: :any_skip_relocation, monterey:       "1db08c37f33e5ce2a5eca4e370806ba3bb7f98fa541ff6ef2275d12da7bd0c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438dc11fa6e20c369e671959cef235aebbb5f81ebf0228ec0b375ed3868b5604"
  end

  depends_on "pkg-config" => :build
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
    (testpath/"Trunk.toml").write <<~EOS
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    EOS

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end
