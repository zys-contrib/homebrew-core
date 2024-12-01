class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "4c012dd5c7f0b1aded454fc16414ca20a6a1fadca2757e699e2addb845eb2ba6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f569a91623ecf5f4d947ffc58963692925f2e62fa5d48d6621e2c564205de4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5e754346755acd5e4641d9bc3c8acf9d6394c2840190272bb7e2002229f439"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b319b41559971d2e7591ac93ad66335d8b45e5c0bbce082ee655d9f73093a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "958091388035d92669139ea6f470fbc66c2f5f6e955d365ed4eb37eb6cbb374b"
    sha256 cellar: :any_skip_relocation, ventura:       "77536f711f697f27814f2b2cdbde98ca1737cf413b7d5abb67e5e8872db9ea31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e5dd453f8a521b2800a3f222a38520d93339ca1d108c3ea7d194eac7e17340"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "image,lyric-finder,notify", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "No cached credentials found", stdout.gets("\n")
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end
