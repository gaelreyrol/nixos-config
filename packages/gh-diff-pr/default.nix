{ writeShellApplication, git, gh, ... }:

writeShellApplication {
  name = "gh-diff-pr";
  runtimeInputs = [ git gh ];
  text = ./gh-diff-pr.sh;
}
