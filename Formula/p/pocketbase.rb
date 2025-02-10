class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "19a3c43207fce22f2e2bd5398aab5204b16923ec430735efc21ae0e4342fefff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4aa237dead48d5a33f99f4f8009aa0ef683e663991886ab4bfb8f6447a4c0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4aa237dead48d5a33f99f4f8009aa0ef683e663991886ab4bfb8f6447a4c0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa4aa237dead48d5a33f99f4f8009aa0ef683e663991886ab4bfb8f6447a4c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "da53e72db09158876173b6532b15b3c1e31bb32d7252a943db8d392dbd407357"
    sha256 cellar: :any_skip_relocation, ventura:       "da53e72db09158876173b6532b15b3c1e31bb32d7252a943db8d392dbd407357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfeda8204a52b3eae9ac917b685502b50cf02d6d9da33fa53a76787fd428b279"
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
