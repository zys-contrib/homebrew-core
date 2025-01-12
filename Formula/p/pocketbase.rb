class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "d92322f3940379f3ab361b20cbf3c61fd3b884a43c677e35c4a2d55bbb205b25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ceb7bae1fb7203732921cc7da3f6a610e850e7da17e7cb3b308291a06260b3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ceb7bae1fb7203732921cc7da3f6a610e850e7da17e7cb3b308291a06260b3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ceb7bae1fb7203732921cc7da3f6a610e850e7da17e7cb3b308291a06260b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33da2524ed2037ec4ba927a92c316cf9e39a8cb168e5f255a0e52e41c37eac25"
    sha256 cellar: :any_skip_relocation, ventura:       "33da2524ed2037ec4ba927a92c316cf9e39a8cb168e5f255a0e52e41c37eac25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e6cb69232da9288db88b36793736faf6a94e4fc7a315a54596baa88c8b1fcd"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/auxiliary.db", :exist?, "pb_data/auxiliary.db should exist"
    assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end
