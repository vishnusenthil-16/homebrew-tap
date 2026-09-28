require "json"

class LatchSecrets < Formula
  desc "Agent-friendly Vaultwarden credentials through the Bitwarden CLI"
  homepage "https://github.com/vishnusenthil-16/latch-secrets"
  url "https://github.com/vishnusenthil-16/latch-secrets/releases/download/v0.2.0/latch-secrets-0.2.0.tar.gz"
  sha256 "7195980906e30cdf54bc187448d9d1f258404e435c1159b62467cf614a2a1e8d"
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
    EOS
  end

  test do
    assert_match "latch 0.2.0", shell_output("#{bin}/latch --version")
    state = testpath/"isolated"
    result = shell_output("#{bin}/latch --state-dir #{state} --json status")
    assert_equal false, JSON.parse(result).fetch("configured")
    refute_path_exists state
  end
end
