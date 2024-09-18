class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.25/source.tar.gz"
  sha256 "93ce5ca3faf5b9809fa32b32b318c2d0903b30608e347786232f85a81c08fe66"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e69982709f29df0e9f2ceff673d56538f4edded6a0819a6512489d2cd43a987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a11d49f3ada721f3d221e2425084ddbcb4cb016310debe59c7a376da3d596882"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a639bd500102ffca0b06e03164e6f725777e4daae4c43c4667fcbe6f49ffa0f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cec7e43edf744f658067eb6d7feec02271c9cc7b0f3911eab1b8170692b2a18a"
    sha256 cellar: :any_skip_relocation, ventura:       "37e0c423dbaad76237f9a190da3b22cfa1274c28c80a2094d44db2e7918eab30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e45c987df6169e962babf574c2387b498c7b28b6df1f8d44d9c0871c13022c"
  end

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = spawn(bin/"sqld")
    sleep 2
    assert_predicate testpath/"data.sqld", :exist?

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
