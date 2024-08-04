class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.39.5.tar.gz"
  sha256 "8f32a00d1163050904188299e64dff28e8c0cd957c40acfa94a18310152611cf"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80ec0a525e6f5ba85d20eafa6de3182e5970e6f14eeb8a717a68875d1d3815c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5fe4e1bd23af353ee3dffb5e587e2f0b77afdb10ffba4806678d3bc3fb54257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c20d7d08ee492fce56fc0545bc38520ede800974b75ba8cb21d0fabcd01b079"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d04abbf52b55fa2dc3682f192d8d872db7f690748d829606f11ba8784ba521a"
    sha256 cellar: :any_skip_relocation, ventura:        "825a524a5a813d6189634ea7d4ebbe32a67aeb1ca5a531910b6d74d261b9eb68"
    sha256 cellar: :any_skip_relocation, monterey:       "aef5d94d4152d98b84c0e72854d01f5a88503ee48a0d972fb50d12ba19139f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9efdfb4fb291317e71045bc81894163e7b458a7e2c3e451159f9ef1a16bc8150"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
