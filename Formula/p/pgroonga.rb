class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.2.3.tar.gz"
  sha256 "93df838222f3536700de3bf0de9305eff1660c6c6c098b4039a52d7f62cc4e7c"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9dc5ef91e59fca8a90bfe2a6c150b9dafe0b776c46c84c8920ff4e2d15c3d6a4"
    sha256 cellar: :any,                 arm64_sonoma:  "b5143fa18b46bff71b0f577ed9c711a759a4a64b68b2a35596e09056e28e0b38"
    sha256 cellar: :any,                 arm64_ventura: "a44cc09219f5f501c6259aa4f49cf23aa3a5bed65fd3c3dcb93463a4534eb903"
    sha256 cellar: :any,                 sonoma:        "458cc2ccb1ab4e79d6191073ba3072ac20710766ee27351b868d4674b890428f"
    sha256 cellar: :any,                 ventura:       "b333826882972cdef176cd59a3d26ae6989c102e7ff87c6c2e294f3d4bcbd1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9946c703416703f1abec4a02304d487b0a64c9a43150f13bb8fba60d350a01a"
  end

  depends_on "pkg-config" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "groonga"

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      with_env(PATH: "#{postgresql.opt_bin}:#{ENV["PATH"]}") do
        system "make"
        system "make", "install", "bindir=#{bin}",
                                  "datadir=#{share/postgresql.name}",
                                  "pkglibdir=#{lib/postgresql.name}",
                                  "pkgincludedir=#{include/postgresql.name}"
        system "make", "clean"
      end
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
