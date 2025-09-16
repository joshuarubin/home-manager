const browsers = {
  arc: {
    name: "Arc",
    openInBackground: false,
  },
  edge: {
    name: "Microsoft Edge",
    openInBackground: false,
  },
  finder: {
    name: "Finder",
    openInBackground: false,
  },
  zen: {
    name: "Zen Browser",
    openInBackground: false,
  },
  zoom: {
    name: "us.zoom.xos",
    openInBackground: false,
  },
};

export default {
  defaultBrowser: browsers.edge,
  options: {
    hideIcon: false,
  },
  rewrite: [
    {
      // Remove all marketing/tracking information from urls
      match: () => true,
      url: ({ url }) => {
        // Remove all query parameters beginning with these strings
        const removeKeysStartingWith = ["utm_", "uta_"];

        // Remove all query parameters matching these keys
        const removeKeys = ["fbclid", "gclid"];

        const search = url.search
          .split("&")
          .map((parameter) => parameter.split("="))
          .filter(
            ([key]) =>
              !removeKeysStartingWith.some((startingWith) =>
                key.startsWith(startingWith),
              ),
          )
          .filter(
            ([key]) => !removeKeys.some((removeKey) => key === removeKey),
          );

        return {
          ...url,
          search: search.map((parameter) => parameter.join("=")).join("&"),
        };
      },
    },
    {
      // Open zoom urls in the Zoom app
      match: ({ url }) =>
        url.host.includes("zoom.us") && url.pathname.includes("/j/"),
      url: ({ url }) => {
        try {
          var pass = "&pwd=" + url.search.match(/pwd=(\w*)/)[1];
        } catch {
          var pass = "";
        }
        var conf = "confno=" + url.pathname.match(/\/j\/(\d+)/)[1];
        return {
          search: conf + pass,
          pathname: "/join",
          protocol: "zoommtg",
        };
      },
    },
    {
      // Open linear urls in the Linear app
      match: ({ url }) => url.host.match(/^(\w+\.)?linear\.app$/),
      url: ({ url }) => {
        if (url.host.match(/^(\w+\.)?uploads\.linear\.app$/)) {
          return url;
        }
        return {
          ...url,
          protocol: "linear",
        };
      },
    },
    // {
    //   // Append `opener_=slack` to all urls opened from Slack so Arc Air Traffic
    //   // Control can match on them
    //   match: ({ opener }) => opener.bundleId === "com.tinyspeck.slackmacgap",
    //   url: ({ url }) => {
    //     const search = url.search
    //       .split("&")
    //       .filter((r) => r !== "")
    //       .concat(["opener_=slack"])
    //       .join("&");
    //
    //     return { ...url, search };
    //   },
    // },
    {
      match: ({ url }) => url.protocol === "s3",
      url: ({ urlString, url }) => {
        if (urlString.search(/post-training-datasets.*parquet/) != -1) {
          return {
            protocol: "https",
            host: "podium.poolsi.de",
            pathname: `/dataset_viewer`,
            search: `dataset_path=${urlString}`,
          };
        }

        const bucket = url.host;
        let path = url.pathname.substring(1); // Remove the leading slash

        return {
          protocol: "https",
          host: "us-east-2.console.aws.amazon.com",
          pathname: `/s3/buckets/${bucket}`,
          search: `prefix=${path}`,
        };
      },
    },
  ],
  handlers: [
    {
      // Open zoom urls in the Zoom app
      match: /zoom\.us\/join/,
      browser: browsers.zoom,
    },
    {
      // Open linear urls in the Linear app
      match: ({ url }) => url.protocol === "linear",
      browser: browsers.finder,
    },
  ],
};
