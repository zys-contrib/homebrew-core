class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.30/source.tar.gz"
  sha256 "b9334866c74103056747753f940c8e597e78b1ab131c1fe37e5d865b4ca2ea8b"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0b7096a59b1936e2106bef20720835f1e4144b7c9ef1972aeaa186ea6b64daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab7546a992bfa03329908b00d023a79b4c8fdb06f6e5a2021489c490f477f47d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "967f4a2905a4778999d1978ca43633dbae273a92868da11117d7f8f707656043"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d07beeb08ba8642f76b00b31d34870d3f352f834fcd75ea00f09fed6c3d41a1"
    sha256 cellar: :any_skip_relocation, ventura:       "56e626f744767e8e70ece90d98fb0f2264cbbbaa89a0bae2d90f9d9d9bda180c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b6e884378c360433b4ed90e09b168e3e4a5e01c8863b96f4e0df5bb4c139cbf"
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
