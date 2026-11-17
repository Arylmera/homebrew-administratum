# Template for the tap Arylmera/homebrew-administratum: the release workflow's homebrew job writes the version and
# both sha256 into it and pushes it there. Keep the shape of those lines, the job's sed patterns depend on it.
cask "administratum" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.0"
  sha256 arm:   "da8d39c3c0580397b93c50648687548ee408f8b34d47b1341e529197c7348b4a",
         intel: "ca4440685333a519cd837cf911453a050c91eeddf38d831f7e512578b981683b"

  url "https://github.com/Arylmera/Administratum/releases/download/v#{version}/Administratum_#{version}_#{arch}.dmg"
  name "Administratum"
  desc "Pixel-art scriptorium widget that watches Claude Code sessions"
  homepage "https://github.com/Arylmera/Administratum"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  # No minimum version: Tauri 2's floor (10.13) is below the oldest macOS Homebrew 7 accepts (:high_sierra is
  # disabled there).
  depends_on :macos

  app "Administratum.app"

  # Not notarized: drop the quarantine flag so Gatekeeper does not call the app damaged. In-app updates download
  # outside the browser and never get the flag.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Administratum.app"],
        writable_paths: ["Administratum.app"],
        writable_base:  :appdir
  end

  zap trash: [
    "~/Library/Application Support/com.arylmera.administratum",
    "~/Library/Caches/com.arylmera.administratum",
    "~/Library/LaunchAgents/Administratum.plist",
    "~/Library/Preferences/com.arylmera.administratum.plist",
    "~/Library/Saved Application State/com.arylmera.administratum.savedState",
    "~/Library/WebKit/com.arylmera.administratum",
  ]
end
