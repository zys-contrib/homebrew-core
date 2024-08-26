class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.29.2.tar.gz"
  sha256 "5119fee67a5ba67fc6e56c6139e67a482cff7f2b37a0b4058ac34b0c462e6229"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "270c64d9e5e91e3d34af7d71458316c047914cd824a52294b6554ac472915523"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9df158ca800decf87565c8cb24c075dffa0e503d71753c8d3ca0ef133cd8452b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3b3bf3dbae45a3e7dbed802721851e2bee2e22f65a8a65c435a869d98c7a702"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1ba1bf7c7030a80cb766b219d1de73b22b071719f4d702fd8a24c9215e30f31"
    sha256 cellar: :any_skip_relocation, ventura:        "9d4c8607034ceaf7b1871c96f633a8ca11e519d9d26a4d88fa73b53c7ffae10e"
    sha256 cellar: :any_skip_relocation, monterey:       "ba2254d6e082aeb8a08523801fa9f003795c2fc50fa2daf5f3477103cf0c3641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e01ec7ce4a09e10ee40e65878c5ac59a9e7f3766bbca264d02dca24cfd0a53"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
