class Smenu < Formula
  desc "Powerful and versatile CLI selection tool for interactive or scripting use"
  homepage "https://github.com/p-gen/smenu"
  url "https://github.com/p-gen/smenu/releases/download/v1.4.0/smenu-1.4.0.tar.bz2"
  sha256 "9b4e0d8864746175c1b20d75f5411fa013abdaf24af6801f1c5549b6698e195b"
  license "MPL-2.0"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"

    PTY.spawn(bin/"smenu", "--version") do |r, _w, _pid|
      r.winsize = [80, 60]

      begin
        assert_match version.to_s, r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
