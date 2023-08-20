{ pkgs, ... }:

{
  config = {
    colorscheme = "NeoSolarized";

    options = {
      number = true;
    };

    extraConfigVim = ''
      set background=light
    '';

    plugins = {
      cmp-treesitter.enable = true;
      dap.enable = true;
      diffview.enable = true;
      gitsigns.enable = true;
      indent-blankline.enable = true;
      lsp.enable = true;
      neo-tree.enable = true;
      nix.enable = true;
      nvim-cmp.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      trouble.enable = true;
      which-key.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      heirline-nvim
      NeoSolarized
      nvim-autopairs
      solarized-nvim
      vim-hardtime
    ];
  };
}
