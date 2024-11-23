{pkgs, ...}: {
  launchd.agents = {
    ollama-serve = {
      enable = true;
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
