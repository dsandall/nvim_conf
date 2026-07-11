-- markview can't render tables with 'wrap' on (its source marks it as a
-- known bug) and its wrap post-processing leaves padding holes in list
-- items; markdown here is hard-wrapped anyway, so soft wrap adds nothing
vim.opt_local.wrap = false
