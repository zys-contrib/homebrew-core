class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "a09b71c3c9b2254ff082f4f759f50300cf69af2d0c216b4ed5008b813a9ad911"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "442372a6483fc59f9c437f10c5e45ac2bfcaa29216ef191e0e6c4ffe5e6a0404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "473c1112638393df76063d391a76bbd5fa2c8090ab6a39ac7b47285078ca37ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceed6b8b90914241ea81df156bdc5e58f1a46173ec8e708a595585488f79150a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d62a32a799eda08f2a2aa1b4cb90a1e80c7d2aab9510607b7d675a3dce7826c"
    sha256 cellar: :any_skip_relocation, ventura:        "f9d488fc387ea784154104839ff3c5f334101beea22c1984d104104b7c3c898f"
    sha256 cellar: :any_skip_relocation, monterey:       "2f24cc7e805241d67f8676393d7acd9b6f6ef0ad520bb46cd9e174a72d37fbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f34ab5eefab635cded8854fcffc3e8ec31f6ba7b453a0719f0d12f7b7ed9a70"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install "#{out_dir}/broot.bash" => "broot"
    (share/"bash-completion/completions").install "#{out_dir}/br.bash" => "br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
