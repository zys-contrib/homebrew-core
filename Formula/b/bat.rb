class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "4433403785ebb61d1e5d4940a8196d020019ce11a6f7d4553ea1d324331d8924"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0725b04fd2c2bc239c1607b2677e3b31f577585ef7937f0b5813be3c7ecb3707"
    sha256 cellar: :any,                 arm64_sonoma:  "ed65b66d398da860e0e9ef1afa9025bac56107dae9eb654114ec93c87fdba6af"
    sha256 cellar: :any,                 arm64_ventura: "fb0fb99732fa593bbc22a6e533c65e1b6187d74ab184dfbdafe3f71bf3b06042"
    sha256 cellar: :any,                 sonoma:        "d5cceac5588236f829a3c56fd5b739b96e6207f7c4fb18bc4440be6a5a1e5064"
    sha256 cellar: :any,                 ventura:       "4162ca42e5b44298ba227d2556a6e4b8fb926e31e4592a8fb3989f475378cd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55dabc13b7034e338f7c8036ff8e1380276242a1b94d87a7697ed7e24cadfba9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
  depends_on "oniguruma"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output

    [
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
