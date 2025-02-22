class Sv2v < Formula
  desc "SystemVerilog to Verilog conversion"
  homepage "https://github.com/zachjs/sv2v"
  url "https://github.com/zachjs/sv2v/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "b64312c995f2d2792fbe610f4a0440259e7e2a9ad9032b37beabf621da51c6da"
  license "BSD-3-Clause"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sv2v --numeric-version")

    (testpath/"test.sv").write <<~VERILOG
      module test;
        initial begin
          $display("Hello, world!");
          $finish;
        end
      endmodule
    VERILOG

    system bin/"sv2v", "test.sv", "--write", "adjacent"
    assert_path_exists testpath/"test.v"
  end
end
