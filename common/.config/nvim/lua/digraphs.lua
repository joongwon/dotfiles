local digraphs = {
  ["[_"] = 0x2291, -- ⊑
  ["_]"] = 0x2292, -- ⊒
  ["O+"] = 0x2295, -- ⊕
  [".["] = 0x230A, -- ⌊
  [".]"] = 0x230B, -- ⌋
  ["[["] = 0x27E6, -- ⟦
  ["]]"] = 0x27E7, -- ⟧
  [".<"] = 0x27E8, -- ⟨
  [".>"] = 0x27E9, -- ⟩
  ["D="] = 0x225C, -- ≜
}
for k, v in pairs(digraphs) do
  vim.cmd(("digraph %s %d"):format(k, v))
end
