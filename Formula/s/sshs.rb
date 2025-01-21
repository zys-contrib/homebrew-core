class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/4.6.0.tar.gz"
  sha256 "58e104dac3a1515f79421b46b22079cc443261c15ca5b97fb025a00775d600ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "19d90512203685dae5603b8586b4ef32663094fdd8990ae5d861e1ee427bdd0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da47dd8e48c44c6ab047184e26dbb0a27e734f4f15054a5a3fa3f5b75aa8bc57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab5e15b46f39c867f5b4aa44b3859fbf37755be1154fc53dedf50996c3ce8013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df8c14aa827ecce6a3bae2ddc90c0f0c66666c5541b0f1d6c5a54c1f80b6d137"
    sha256 cellar: :any_skip_relocation, sonoma:         "975ae1e62f123e67307525ee64826b32312b2893b6ede2c22b92073d5af044d8"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c9be09ebbc8f9d8fbbdbb689080859313fe3d23ce9167c8cba72cfb1314344"
    sha256 cellar: :any_skip_relocation, monterey:       "f8aa7f03a3795763e1e6f28ebba23259c156845cc6afe3be78baf1e323351b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80926cbd296201a8c52ade54290768a4b977152a551b1310e0df469f8c73114"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, https://github.com/quantumsheep/sshs/pull/115
  patch do
    url "https://github.com/quantumsheep/sshs/commit/de24632c4a83beb82ca041f4cfaa5e1c534993b3.patch?full_index=1"
    sha256 "40c0e71b5fd3edc06250f1e4775395c49607dca7c3da6c36065e0c084a8e2b9f"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "sshs #{version}", shell_output(bin/"sshs --version").strip

    (testpath/".ssh/config").write <<~EOS
      Host "Test"
        HostName example.com
        User root
        Port 22
    EOS

    require "pty"
    require "io/console"

    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"sshs") do |r, w, _pid|
      r.winsize = [80, 40]
      sleep 1

      # Search for Test host
      w.write "Test"
      sleep 1

      # Quit
      w.write "\003"
      sleep 1

      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
