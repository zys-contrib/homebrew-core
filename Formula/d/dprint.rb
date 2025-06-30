class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.50.1.tar.gz"
  sha256 "85197a9469fe479fc278e77e87ede6eeb55b7d42d0a530e8b828f3ab9b213358"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7893a7360baa4540a8f29c450d0670449db12cd9d857e7ca9854631668ad30d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "703e06bef2c9c9d0fb74d03bd00a303398d4001080653101a8bd4f72547c7d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59299e27deee4819d4d47cecdbf93cc9d0412d6ff34ce645260fc232ff1a439"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b08795bea3987a248af08fadd243fff4f35eea291069c15224b0e34b876f32"
    sha256 cellar: :any_skip_relocation, ventura:       "ffe2efb94cdaff94ee5833ea56cea07eee8821227d92e6df7f4a131b2d64ae87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e215fd8b93370de515391208e0294bc6da83308d9b08f7631fb1df8e61319ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f9512b0ba9365009f00e66fd0dacd276afa2a8ffbd265a050b8e7098d2aa83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # update deps, upstream pr ref, https://github.com/dprint/dprint/pull/1003
  patch do
    url "https://github.com/dprint/dprint/commit/bb6ddc6034f73adb188fb2c40aa34d0c6a7ec6de.patch?full_index=1"
    sha256 "ea54bc0c12dbd3057a0c95d4c922fd35459f338112c14eb8dc4fe96eb742a733"
  end

  def install
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
