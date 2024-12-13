class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://github.com/MusicPlayerDaemon/MPD"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  stable do
    url "https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.16.tar.gz"
    sha256 "a3ba8a4ef53c681ae5d415a79fbd1409d61cb3d03389a51595af24b330ecbb61"

    # support libnfs 6.0.0, upstream commit ref, https://github.com/MusicPlayerDaemon/MPD/commit/31e583e9f8d14b9e67eab2581be8e21cd5712b47
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/557ad661621fa81b5e6ff92ab169ba40eba58786/mpd/0.23.16-libnfs-6.patch"
      sha256 "e0f2e6783fbb92d9850d31f245044068dc0614721788d16ecfa8aacfc5c27ff3"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3af030e17bd7433e049c2341b7f3f321e0965c27252655b69b18306d8d992c6d"
    sha256 cellar: :any, arm64_sonoma:  "cabab5a22d663c2e833fe58fddbdcb03cfbb62a84e4cd107fa5dec021c7a9302"
    sha256 cellar: :any, arm64_ventura: "369c7be3485037c3acb899eb458379d242eb8a08fe1cd22f16cc6f91d4f8015b"
    sha256 cellar: :any, sonoma:        "f8fd84ded5edf6e72cb449f7a497af00cc5dd79f8726c5b623a982de9ed37bf8"
    sha256 cellar: :any, ventura:       "4b5f3543fc9c7ecf05c159e4493698b2e2258c7e4b26f0097508c92484963323"
    sha256               x86_64_linux:  "4002b2017b63e8f966c7bb9002f89cd8f1009e2fd4fff956bcc5ea39305c274a"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "chromaprint"
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "game-music-emu"
  depends_on "glib"
  depends_on "icu4c@76"
  depends_on "lame"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "libid3tag"
  depends_on "libmikmod"
  depends_on "libmpdclient"
  depends_on "libnfs"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on macos: :mojave # requires C++17 features unavailable in High Sierra
  depends_on "mpg123"
  depends_on "opus"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "wavpack"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "jack"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    args = %W[
      -Dcpp_std=c++20
      --sysconfdir=#{etc}
      -Dmad=disabled
      -Dmpcdec=disabled
      -Dsoundcloud=disabled
      -Dao=enabled
      -Dbzip2=enabled
      -Dchromaprint=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dshout=enabled
      -Dupnp=pupnp
      -Dvorbisenc=enabled
      -Dwavpack=enabled
      -Dgme=enabled
      -Dmikmod=enabled
      -Dsystemd_system_unit_dir=#{lib}/systemd/system
      -Dsystemd_user_unit_dir=#{lib}/systemd/user
    ]

    system "meson", "setup", "output/release", *args, *std_meson_args
    system "meson", "compile", "-C", "output/release", "--verbose"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "meson", "install", "-C", "output/release"

    pkgetc.install "doc/mpdconf.example" => "mpd.conf"
  end

  def caveats
    <<~EOS
      MPD requires a config file to start.
      Please copy it from #{etc}/mpd/mpd.conf into one of these paths:
        - ~/.mpd/mpd.conf
        - ~/.mpdconf
      and tailor it to your needs.
    EOS
  end

  service do
    run [opt_bin/"mpd", "--no-daemon"]
    keep_alive true
    process_type :interactive
    working_dir HOMEBREW_PREFIX
  end

  test do
    # oss_output: Error opening OSS device "/dev/dsp": No such file or directory
    # oss_output: Error opening OSS device "/dev/sound/dsp": No such file or directory
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "[wavpack] wv", shell_output("#{bin}/mpd --version")

    require "expect"

    port = free_port

    (testpath/"mpd.conf").write <<~EOS
      bind_to_address "127.0.0.1"
      port "#{port}"
    EOS

    io = IO.popen("#{bin}/mpd --stdout --no-daemon #{testpath}/mpd.conf 2>&1", "r")
    io.expect("output: Successfully detected a osx audio device", 30)

    ohai "Connect to MPD command (localhost:#{port})"
    TCPSocket.open("localhost", port) do |sock|
      assert_match "OK MPD", sock.gets
      ohai "Ping server"
      sock.puts("ping")
      assert_match "OK", sock.gets
      sock.close
    end
  end
end
