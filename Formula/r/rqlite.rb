class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.29.1.tar.gz"
  sha256 "4602048aad1d09aa8e1b36e723fb2e75fbf3bac8fa10b89d1c38d47aaba9e9ed"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26e624cd0e3801f0ae3fe5275d441c308cb28095cd4902028f65bed67e357197"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae8f83ff22ffddcee16f64fe009d4912f0936c7c524f74f00676edd25e0de5bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45f8a52354dc7cb950821e41f61c04a04608eab5f22affffff58da517c9a3e94"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ce3ddc926f57a538805beb7c1cffb52ca87acbb8a90f12f13e12b871115849b"
    sha256 cellar: :any_skip_relocation, ventura:        "3b52a99c3c1159da5fc408ad2da9dc996fd85c299513fa30ae94a4ce2b51f02d"
    sha256 cellar: :any_skip_relocation, monterey:       "8672652f49561cdc58192a85f7860c725e0c17968302932e7489577bac1d988c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8f7eb70dd5222264271d7353a2aec51d3ae6d7031a10022c938aeae52ab19d"
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
