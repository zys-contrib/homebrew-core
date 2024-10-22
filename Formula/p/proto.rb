class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.41.7.tar.gz"
  sha256 "6346177d6f55409d30a38d8fba0e494801bffbeb7644680f058c6a91132685ea"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4f1c726e6594ba0dc75f80f1aefdebe408b08a00a9dadb2917548423980be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "659c766accffaf9f285a7a12b934ddb2a403a9df8e796f41710af0375cfa7160"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "797db1da9bac3a4cdd00663ee30804cc24067f9ab3532ab5eb55ddb85354886f"
    sha256 cellar: :any_skip_relocation, sonoma:        "084b3e53c69b74cba61eb0fa765c866530d83076d3cc7f39b567c1bb6db19473"
    sha256 cellar: :any_skip_relocation, ventura:       "6c8a7fe5d198b17043f555b9d74535cdca49276ce06a845043d30e4b26e0626b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f897eecb1269b7cb37f84f191fa7f680a3152247dfe94b4e3915f272130378f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
