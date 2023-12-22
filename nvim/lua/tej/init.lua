require("tej.lazy")

-- Open telescope if no files are opened.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argv(0) == "" then
      local is_git_repo = vim.fn.isdirectory(".git") == 1

      if is_git_repo then
        vim.cmd(":Easypick unstaged_changes")
      else
        require("telescope.builtin").find_files({
          hidden = true,
        })
      end
    end
  end,
})
