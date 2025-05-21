class FlipLink < Formula
  desc "Adds zero-cost stack overflow protection to your embedded programs"
  homepage "https://github.com/knurling-rs/flip-link"
  url "https://github.com/knurling-rs/flip-link/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "9389806ffda4ed5aa47f39fc71ac2a19be59cc28aab93bfb32bb514ed7165f75"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
    (pkgshare/"examples").install "test-flip-link-app"
  end

  test do
    # Don't apply RUSTFLAGS when building firmware
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "thumbv7em-none-eabi"

    cp_r pkgshare/"examples"/"test-flip-link-app", testpath

    cd "test-flip-link-app" do
      system "cargo", "build"
    end
  end
end
