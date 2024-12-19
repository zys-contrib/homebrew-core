class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.23.11.tar.gz"
  sha256 "564c3eff7a57e7f5913840f0ce85b09d01eba6e19ee6ea4c93cfd78fbdbf2653"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9581319ba38e30772df16464c6180fa486dae5f04247048916f61b11285715cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9581319ba38e30772df16464c6180fa486dae5f04247048916f61b11285715cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9581319ba38e30772df16464c6180fa486dae5f04247048916f61b11285715cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "30a43ba5ee04efe9956f62257064a442e7d4a138c164d5ae8f56eb82d33ddda3"
    sha256 cellar: :any_skip_relocation, ventura:       "30a43ba5ee04efe9956f62257064a442e7d4a138c164d5ae8f56eb82d33ddda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab6fb3b7fe9fb8d59ec72f677c87d2d442d26bd941c8ef269b76687dfa67dcc"
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
