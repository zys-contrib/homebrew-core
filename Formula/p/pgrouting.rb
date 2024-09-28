class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.6.2/pgrouting-3.6.2.tar.gz"
  sha256 "f4a1ed79d6f714e52548eca3bb8e5593c6745f1bde92eb5fb858efd8984dffa2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "72bcce1166646529d4aeb408330cba78c6902ad638f068fbd827917860a4d5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b52b48a48c4b3a31d1d2108ab218e7c64642d5dfe8fe2e5542110379f206b452"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd74845f8712c27dde09e677efc5f61185286c5d4dcaffd2957e1f2f43cb078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d6781d06872f26d8d8241b440bdd0dc1df1e652c9c84778e37ca6aaf3f27a9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4a7d141b8df468e8d66852f2d1639c07a319734cc898b829b2740780bfce578"
    sha256 cellar: :any_skip_relocation, ventura:        "be72ca847766199f95fb99e58c2f25f101a86aeac1116a6ab8ec00d68eef28eb"
    sha256 cellar: :any_skip_relocation, monterey:       "bb08d1c14eae4b92a51433d5becb5f8c074e87513d10429d29a88f9e0299bad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9d83c063ea735b32fb4e1abdab9d567003c42c3fe8144bbf648e3147167d6f7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgis"

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    ENV["DESTDIR"] = buildpath/"stage"

    postgresqls.each do |postgresql|
      builddir = "build-pg#{postgresql.version.major}"
      args = ["-DPOSTGRESQL_PG_CONFIG=#{postgresql.opt_bin}/pg_config"]
      # CMake MODULE libraries use .so on macOS but PostgreSQL 16+ looks for .dylib
      # Ref: https://github.com/postgres/postgres/commit/b55f62abb2c2e07dfae99e19a2b3d7ca9e58dc1a
      args << "-DCMAKE_SHARED_MODULE_SUFFIX_CXX=.dylib" if OS.mac? && postgresql.version >= 16

      system "cmake", "-S", ".", "-B", builddir, *args, *std_cmake_args
      system "cmake", "--build", builddir
      system "cmake", "--install", builddir
    end

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
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

        shared_preload_libraries = 'libpgrouting-#{version.major_minor}'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgrouting\" CASCADE;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
