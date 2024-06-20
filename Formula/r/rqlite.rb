class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.26.2.tar.gz"
  sha256 "5e77e278b9905c78e77bdf3a54e4d21af8b68e0041e4adaf3178b6aba98b2977"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "194f2cda4754cc7b8355b65fd6e23044c63c7f8c1e6cf14a0dbd74e4009b0e01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6220a3346a74409affb8657c6435088c7f9bc14750ff2e432e0e5a010b6e5b76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964a05f8745f983739f0e5d3f97749dceecb2c1cfb717bbd5a8573fcf4b291ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6b649a0c7ff9b2b3cbe610957ca82614f22b338b565865c34f62b11aa6223aa"
    sha256 cellar: :any_skip_relocation, ventura:        "824e160f022b156be135bb83389216ad228ec0551bcae7649c09e47a4b969880"
    sha256 cellar: :any_skip_relocation, monterey:       "e1064fe8484989dbdd5d12b5a20240a734d1c80958350aff59dda7f15ffc7d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d92964b976c257a307aedef464e6f01ba02f8668609cb9ccc2ff1ce542a767"
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
