cask "agenttap" do
  version "0.9.0"
  sha256 "dbb235362649cb9a895941e89cefcb44932fc5add03059a6d42aba4ab83c1484"

  url "https://github.com/GeiserX/AgentTap/releases/download/v#{version}/AgentTap-#{version}.dmg"
  name "AgentTap"
  desc "Network-level AI agent observability via transparent HTTPS capture"
  homepage "https://github.com/GeiserX/AgentTap"

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
