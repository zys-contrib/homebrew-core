class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.36.18.tar.gz"
  sha256 "c9c7c0e0b6303ba86c8982cfb1fb48d388c0b4088c3400ee010ef4daf3cc5a7c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40d4ff87bc6a27b5e07cf4274e93c1681cba0b4e36de8ecf4345d4083fbbb7b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27cdecf4ad5166e587d3c94bc8e5808a301895662f5a6e8ea7ae672ae606e869"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8606df50f53a2c615b6871c355fe38e54eea3f5bf0eaec2114c3e96be438424d"
    sha256 cellar: :any_skip_relocation, sonoma:        "738b88d21c6c5c8d307abc5eab89e5cf681b5db26f94aa5361d6ff9b68e8b806"
    sha256 cellar: :any_skip_relocation, ventura:       "d024d37d11163757e712f96fc39758cbdba558b9994ba75aa8da2dd6c9cd4de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e65731bc1dc0dc2dcb83dd3c59cf99dc383ef0ddcae4b8735f5dfd821dae6ea"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
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

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
