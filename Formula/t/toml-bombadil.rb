class TomlBombadil < Formula
  desc "Dotfile manager with templating"
  homepage "https://github.com/oknozor/toml-bombadil"
  url "https://github.com/oknozor/toml-bombadil/archive/refs/tags/4.2.0.tar.gz"
  sha256 "b911678642a1229908dfeabbdd7f799354346c0e37f3ac999277655e01b6f229"
  license "MIT"
  head "https://github.com/oknozor/toml-bombadil.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    config_dir = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end

    config_dir.mkpath
    (config_dir/"bombadil.toml").write <<~TOML
      dotfiles_dir = "dotfiles"
    TOML

    (testpath/"dotfiles").mkpath

    ENV["HOME"] = testpath

    output = shell_output("#{bin}/bombadil get vars")

    assert_match(/"arch":\s*".+"/, output)
    assert_match(/"os":\s*".+"/, output)
  end
end
