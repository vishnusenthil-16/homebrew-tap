require "json"

class LatchSecrets < Formula
  desc "Agent-friendly Vaultwarden credentials through the Bitwarden CLI"
  homepage "https://github.com/vishnusenthil-16/latch-secrets"
  url "https://github.com/vishnusenthil-16/latch-secrets/releases/download/v0.2.1/latch-secrets-0.2.1.tar.gz"
  sha256 "aad90dcd982f56c2a5b518121a4bac5a087d3589c00ff6e48f4a89340ff193c0"
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
    assert_match "latch 0.2.1", shell_output("#{bin}/latch --version")
    state = testpath/"isolated"
    result = shell_output("#{bin}/latch --state-dir #{state} --json status")
    assert_equal false, JSON.parse(result).fetch("configured")
    refute_path_exists state
  end
end
