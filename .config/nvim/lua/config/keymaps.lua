-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- custom keymaps
local keymap = vim.keymap

keymap.set({ "n", "v" }, "h", "i", { noremap = true })
keymap.set({ "n", "v" }, "H", "I", { noremap = true })
keymap.set({ "n", "v" }, "j", "h", { noremap = true })
keymap.set({ "n", "v" }, "k", "j", { noremap = true })
keymap.set({ "n", "v" }, "i", "k", { noremap = true })

-- Better Movements
keymap.set({ "n", "v" }, "J", "0", { noremap = true })
keymap.set({ "n", "v" }, "L", "$", { noremap = true })
keymap.set({ "n", "v" }, "I", "5k", { noremap = true })
keymap.set({ "n", "v" }, "K", "5j", { noremap = true })
-- keymap.set({ "n", "v" }, "W", "5w", { noremap = true })
-- keymap.set({ "n", "v" }, "B", "5b", { noremap = true })

keymap.set("n", "<A-j>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
keymap.set("n", "<A-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-j>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap.set("n", "<C-k>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap.set("n", "<C-i>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move Lines
keymap.set("n", "<A-k>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap.set("n", "<A-i>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap.set("i", "<A-k>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
keymap.set(
  "n",
  "<F5>",
  "<cmd>TermExec cmd='/home/lijy19/anaconda3/bin/python %' go_back=0<cr>",
  { desc = "Run Python file" }
)
