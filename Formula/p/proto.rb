class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.39.7.tar.gz"
  sha256 "fb7334967aaa735788dfa5caae3b01326c0f7a8f3754f92fb4f4b7197ff89ec7"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d96a75d72a509590897085d4d2c1d0f150322ab8ce5d6f1435b061ea306ed1b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17fadf3864af9361285d26db77fc83d90222e10e9ee7da6989b0429b665d39b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f5a40c70db28227c1fc6231a76da23268daf5d35c01202eb7054d777d8539e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "119a49500349d19bce0853d40ee2b60ed8aeccaee86a232138b37d403e9b0fff"
    sha256 cellar: :any_skip_relocation, ventura:        "830ef84644ae4625474b3220f40cc67577ff29c776b1a0e07f09e6dc8b083665"
    sha256 cellar: :any_skip_relocation, monterey:       "19c724bcc00e5d0ffffa30f93b085834f5af02bf6816372cf4d011ff113857a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84551f680a9f4a17319e4a6b8f5c336784f277a8dd5d5df192092abb7b19a9e"
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
