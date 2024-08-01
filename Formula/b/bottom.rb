class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.10.1.tar.gz"
  sha256 "c0e507cc3a5246e65521e91391410efc605840abe3b40194c5769265051fa1cc"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9317f6bc4fa67e19b736286a92916dc9d6feea0c6a39179c642333fb0aac1a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5624ee3437c1a42dda35a135db1ae62ac14e37dbd1f7d5bc0b2d812366e0630f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5f9d9ffa8a3e94d50fde543aa6212de50071a17b78effac81646f41fe2aae0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4cb492c4ce4739eaf2ad402ffa5e00b0cacfb161b32d51357fe283fdfd8198d"
    sha256 cellar: :any_skip_relocation, ventura:        "83d80fa54b74ee8125833bce789e6681ae3ce13b814b68bf963b20df2018b81c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4413cb6a6c217740828c42dfd436214c2219e6e6e81767a2482cf0b82bff207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a0ecf3985e6991c7847351574b00a63fb62e7e6060eb2b41605b5448b28bfc"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output(bin/"btm --invalid 2>&1", 2)
  end
end
