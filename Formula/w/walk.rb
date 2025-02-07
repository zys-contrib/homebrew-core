class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "e28e48ec88de76be2b21fffa81ced159d78b9fd0b5e8abe0e19cbff086bf26d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8162f9abc82a904dc190531e957c42cfdbc32ca6b6dcc413831a36d0785dfed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8162f9abc82a904dc190531e957c42cfdbc32ca6b6dcc413831a36d0785dfed8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8162f9abc82a904dc190531e957c42cfdbc32ca6b6dcc413831a36d0785dfed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d3be60e61d5d0b7056aafa5f0bdd5117511fd73207020c546e6bcd1e54fb61b"
    sha256 cellar: :any_skip_relocation, ventura:       "1d3be60e61d5d0b7056aafa5f0bdd5117511fd73207020c546e6bcd1e54fb61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d497ad574c83bbd5aea3eac58f6c61d882c9bdecd7ecb61dbc77765ca614df"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
