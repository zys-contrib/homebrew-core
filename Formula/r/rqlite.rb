class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.28.0.tar.gz"
  sha256 "6f5d40d6a556d4158f6eea3e509ba89024edd2d1409ad46a0020739299475761"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c7b10b9e5d3def579d705308f765fbbdf11b66a4ccdbe1fff3b96cc73428129"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61b1937f5d53cdaa9246d4e69c336f8d4126cc80b3d40ea85dda904f994d56fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d93a7bb1a555d6ce6091467153ccd6ec6069755f3ec3bcf3ef66ae12d51dd0ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "eced5c060b17363c71eed514453ab8ea108d53bf2f6deca5aaa1e55a097bbad6"
    sha256 cellar: :any_skip_relocation, ventura:        "b141f890ca880ae76ea89503275a153bb926cb8460cb9e9c4ffa737c759a72f0"
    sha256 cellar: :any_skip_relocation, monterey:       "3cbd812e3b6703a16963b47408b30a27643c0cb929b38ac9d3c0d06ec3ec8c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4534339f212442e11d02d0f8f9022e7f03825e82760901b4ec969d441ebaeddf"
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
