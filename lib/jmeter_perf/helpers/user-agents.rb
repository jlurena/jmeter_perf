# This module provides a collection of common user-agent strings for various devices and browsers.
# It allows retrieval of user-agent strings based on device type.
module JmeterPerf::Helpers
  module UserAgent
    # A hash containing user-agent strings for common devices and browsers.
    # @return [Hash<Symbol, String>] the user-agent strings for various devices and browsers.
    COMMON_DEVICES = {
      # User-agent string for iPhone
      iphone: "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1",
      # User-agent string for iPod
      ipod: "Mozilla/5.0 (iPod touch; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1",
      # User-agent string for iPad
      ipad: "Mozilla/5.0 (iPad; CPU OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1",
      # User-agent string for Safari on macOS
      safari_osx: "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15",
      # User-agent string for Safari on Windows
      safari_win: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 Edg/115.0.1901.188",
      # User-agent string for Edge
      edge: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 Edg/115.0.1901.188",
      # User-agent string for Chrome on macOS
      chrome_osx: "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36",
      # User-agent string for Chrome on Windows
      chrome_win: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36",
      # User-agent string for Firefox on macOS
      ff_osx: "Mozilla/5.0 (Macintosh; Intel Mac OS X 13.0; rv:115.0) Gecko/20100101 Firefox/115.0",
      # User-agent string for Firefox on Windows
      ff_win: "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:115.0) Gecko/20100101 Firefox/115.0",
      # User-agent string for Opera on macOS
      opera_osx: "Mozilla/5.0 (Macintosh; Intel Mac OS X 13.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 OPR/102.0.0.0",
      # User-agent string for Opera on Windows
      opera_win: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36 OPR/102.0.0.0"
    }

    # Retrieves the user-agent string for the specified device.
    #
    # @param device [Symbol] the device type for which to retrieve the user-agent string.
    # @return [String] the user-agent string for the specified device, or the default Chrome on macOS user-agent string if the device is not found.
    def self.string(device)
      COMMON_DEVICES[device] || COMMON_DEVICES[:chrome_osx]
    end
  end
end
