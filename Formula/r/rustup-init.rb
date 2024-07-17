class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.27.1.tar.gz"
  sha256 "f5ba37f2ba68efec101198dca1585e6e7dd7640ca9c526441b729a79062d3b77"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1248c64af2a4c08f32d39ef40c4c65472f4d7cf9c447deeb7bc74fd6c8d1195b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbbac142b00f35868ca7e34d2a5aa0e9922db072f38efd9fbb68d0bd4d4b4be2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7018b1fe83019ab4c5925c79248bfd56b690ee65f7a2d9ff3eb6ef392a7aca9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9b11990998ed99fbedca4e8aadcb65d953f0f0711ce72620274b1b4d800c68f"
    sha256 cellar: :any_skip_relocation, ventura:        "a847079013df936ee23ee50e4bd4a4cabcec0e6fcbd3512efb11eabe3d514dd4"
    sha256 cellar: :any_skip_relocation, monterey:       "e0e14890c70d0c103753a2861cda3b44092471acdec51b14ce0c7ffa1b10261d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d9ff7b986a355cb60bff64754c0cb7213361a48e02991e246d8f7b242f38de9"
  end

  keg_only "it conflicts with rust"

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=no-self-update", *std_cargo_args

    %w[cargo cargo-clippy cargo-fmt cargo-miri clippy-driver rls rust-analyzer
       rust-gdb rust-gdbgui rust-lldb rustc rustdoc rustfmt rustup].each do |name|
      bin.install_symlink bin/"rustup-init" => name
    end
    generate_completions_from_executable(bin/"rustup", "completions", base_name: "rustup")
  end

  def post_install
    (HOMEBREW_PREFIX/"bin").install_symlink bin/"rustup", bin/"rustup-init"
  end

  def caveats
    <<~EOS
      To initialize `rustup`, set a default toolchain:
        rustup default stable
    EOS
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".rustup"
    ENV.prepend_path "PATH", bin

    assert_match "no default is configured", shell_output("#{bin}/rustc --version 2>&1", 1)
    system bin/"rustup", "default", "stable"

    system bin/"cargo", "init", "--bin"
    system bin/"cargo", "fmt"
    system bin/"rustc", "src/main.rs"
    assert_equal "Hello, world!", shell_output("./main").chomp
    assert_empty shell_output("#{bin}/cargo clippy")

    # Check for stale symlinks
    system bin/"rustup-init", "-y"
    bins = bin.glob("*").to_set(&:basename).delete(Pathname("rustup-init"))
    expected = testpath.glob(".cargo/bin/*").to_set(&:basename)
    assert (extra = bins - expected).empty?, "Symlinks need to be removed: #{extra.join(",")}"
    assert (missing = expected - bins).empty?, "Symlinks need to be added: #{missing.join(",")}"
  end
end
