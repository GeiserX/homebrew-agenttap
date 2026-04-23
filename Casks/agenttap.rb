cask "agenttap" do
  version "0.15.9"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"

  url "https://github.com/neutralbase/agent-tap/releases/download/v#{version}/AgentTap-#{version}.dmg"
  name "AgentTap"
  desc "Network-level AI agent observability via transparent HTTPS capture"
  homepage "https://github.com/neutralbase/agent-tap"

  depends_on macos: ">= :ventura"

  app "AgentTap.app"

  preflight do
    system_command "/usr/bin/pkill",
                   args: ["-x", "AgentTap"],
                   sudo: false,
                   must_succeed: false
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/AgentTap.app"],
                   sudo: false

    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", "#{appdir}/AgentTap.app"],
                   sudo: false

    system_command "/usr/bin/open",
                   args: ["#{appdir}/AgentTap.app"],
                   sudo: false,
                   must_succeed: false
  end

  uninstall launchctl: "com.geiserx.agenttap.helper",
            delete:    [
              "/Library/PrivilegedHelperTools/com.geiserx.agenttap.helper",
              "/Library/LaunchDaemons/com.geiserx.agenttap.helper.plist",
            ]

  zap trash: [
    "~/Library/Application Support/AgentTap",
    "~/Library/Preferences/com.geiserx.agenttap.plist",
    "~/Library/Caches/com.geiserx.agenttap",
  ]
end
