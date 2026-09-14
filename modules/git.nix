{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Vladimir Markov";
    userEmail = "49807858+withoutboat@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
