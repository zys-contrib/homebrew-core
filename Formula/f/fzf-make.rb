class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "364f6769b22377130d10fe3f8656a5bb1832b39ee6f0ed50cae5a00d72ba8c06"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "245fc9e9c93666139ab0cbc5326a975c4393d3e2bb8cea5255d3ea0800a99349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da65dae30d89c35968043d006738d334719f1de26e863c86cde2030e79e8d1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f76bf80ad1dab48c6e597484086c8706cc826e9dcb24084af0125c6c4f894947"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5114459759558549545319864f37d26f3a733116461da0549bd097e233508b9"
    sha256 cellar: :any_skip_relocation, ventura:       "adb4acce980f29bbde17bbb9cf84e1431577a7b13d9db944ec8549bbe97a6dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d4903b51443007ca39d20d87e6f1e4fde8214d7f5efbe8e4d232b018938e96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
