{pkgs, ...}: {
  launchd.agents = {
    ollama-serve = {
      enable = false;  # temporarily disabled - ollama build fails in 25.11
      config = {
        ProgramArguments = ["${pkgs.ollama}/bin/ollama" "serve"];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/ollama.out.log";
        StandardErrorPath = "/tmp/ollama.err.log";
      };
    };
  };
}
