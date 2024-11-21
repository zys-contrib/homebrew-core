class Sixtunnel < Formula
  desc "Tunnelling for application that don't speak IPv6"
  homepage "https://github.com/wojtekka/6tunnel"
  url "https://github.com/wojtekka/6tunnel/releases/download/0.13/6tunnel-0.13.tar.gz"
  sha256 "8bc00d8dcd086d13328d868a78e204d8988b214e0c0f7fbdd0794ffe23207fe5"
  license "GPL-2.0-only"

  head do
    url "https://github.com/wojtekka/6tunnel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "netcat" => :test

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    require "socket"
    dest_port = free_port
    proxy_port = free_port
    server = TCPServer.new dest_port

    fork do
      loop do
        session = server.accept
        session.puts "Hello world!"
        session.close
      end
    end

    sleep 1

    fork do
      exec bin/"6tunnel", "-1", "-4", "-d", proxy_port.to_s, "localhost", dest_port.to_s
    end

    sleep 1

    assert_equal "Hello world!", shell_output("nc localhost #{proxy_port}").chomp
  end
end
