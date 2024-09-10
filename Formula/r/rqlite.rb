class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.30.1.tar.gz"
  sha256 "c9c8f8ab2ac2815853a29c46a1fd10e94cb7d53a811c22d48f3c52d0d0493b2c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90b5b6ba7a765f331f9f013cc3b50ab0cfa340aef79986b5fa668117388ffda4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f2f26e3ef320a24b9d483fcf7849fa952ef6e126b2e1462522dccde2802a560"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23d5d82c696782d473de93b69563dcec7ced18c77c14983649440c4e24ef0b09"
    sha256 cellar: :any_skip_relocation, sonoma:         "d65bfa4fd10b235b96b2dc483b229fefb0f71758d04e4160846c439293694abb"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5b134c4fb6a20d21f4ce2f5bbe3fb95c6fd591b19ea85bb6e3a872cd1e868c"
    sha256 cellar: :any_skip_relocation, monterey:       "8b2feb574c74165d9fe5efdacba8b0dec241d0047d22649d0a676ee2ed517c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d58abe053aa04fddc09678731c725167c6c011e1634d6489ded4d2d1216ff477"
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
