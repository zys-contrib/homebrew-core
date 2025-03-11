class RaMultiplex < Formula
  desc "Share one rust-analyzer instance between multiple LSP clients to save resources"
  homepage "https://github.com/pr2502/ra-multiplex"
  url "https://github.com/pr2502/ra-multiplex/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "c24a7e277adce9bbfb86641905d75f166e46459cf4e5b5f3aaa7456b052392dc"
  license "MIT"
  head "https://github.com/pr2502/ra-multiplex.git", branch: "main"

  depends_on "rust" => :build
  depends_on "rust-analyzer"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ra-multiplex", "server"]
    keep_alive true
    error_log_path var/"log/ra-multiplex.log"
    log_path var/"log/ra-multiplex.log"

    # Need cargo and rust-analyzer in PATH
    environment_variables PATH: std_service_path_env
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": null,
          "initializationOptions": {},
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 2,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    begin
      pid = spawn bin/"ra-multiplex", "server"
      assert_match output, pipe_output(bin/"ra-multiplex", input, 0)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
