class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.0.tar.gz"
  sha256 "bcadb61a2af9ae23f81ca55318d2b3f263cdd4012b4d136d16be3462e623c3e2"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  depends_on "go" => :build

  def install
    tags = %w[
      vtable
      fts5
      sqlite_json
      sqlite_math_functions
    ].join(",")
    system "go", "build", "-tags", tags, *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"anyquery", "completion")
  end

  test do
    assert_match "no such table: non_existing_table",
                 shell_output("#{bin}/anyquery -q \"SELECT * FROM non_existing_table\"")
    # test server
    pid = fork do
      system bin/"anyquery", "server"
    end
    sleep 20
  ensure
    Process.kill("TERM", pid)
  end
end
