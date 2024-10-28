class Boring < Formula
  desc "`boring` SSH tunnel manager"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/0.6.0.tar.gz"
  sha256 "460b007759ab2956da2b0f56478cff1574dc668791842c55aa9c2e2c25b03a3d"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"
  end

  test do
    assert_match version.to_s, shell_output(bin/"boring", 1)

    # first interaction with boring should create the user config file
    # and correctly output that no tunnels are currently configured
    output = shell_output("#{bin}/boring list")
    assert output.end_with?("No tunnels configured.\n")
    assert_predicate testpath/".boring.toml", :exist?

    # now add an example tunnel and check that it is parsed correctly
    test_config = testpath/".boring.toml"
    test_config.write <<~EOF, mode: "a+"
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    EOF
    output = shell_output("#{bin}/boring list")
    assert_match "dev   9000   ->  localhost:9000  dev-server", output
  end
end
