require "json"

class LatchSecrets < Formula
  desc "Agent-friendly Vaultwarden credentials through the Bitwarden CLI"
  homepage "https://github.com/vishnusenthil-16/latch-secrets"
  url "https://github.com/vishnusenthil-16/latch-secrets/releases/download/v0.3.0/latch-secrets-0.3.0.tar.gz"
  sha256 "79c18d5337098a5a02492e239580072fa0288a1e76e8872615469e0bb39d5645"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on :macos

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    args = std_cargo_args
    args << "--offline" unless args.include?("--offline")
    system "cargo", "install", *args
    (pkgshare/"skills").install "skills/latch"
  end

  def caveats
    <<~EOS
      Configure explicitly with `latch configure --server URL --bw /absolute/path/to/bw`.
      Install Bitwarden CLI separately and pin version 2026.8.0 for the
      supported Vaultwarden server. No service is started by this formula.
      Browser fill additionally requires Node.js 22.4+ on PATH.
    EOS
  end

  test do
    assert_match "latch 0.3.0", shell_output("#{bin}/latch --version")
    state = testpath/"isolated"
    result = shell_output("#{bin}/latch --state-dir #{state} --json status")
    assert_equal false, JSON.parse(result).fetch("configured")
    refute_path_exists state
  end
end
