vim9script

if &termguicolors || has('gui_running')
  echoerr "boa colorscheme designed only for terminal. Set notermguicolors"
endif

set background=dark
highlight clear
g:colors_name = 'boa'

const colors = {
  norm_back: '0',
  red: '1',
  green: '2',
  orange: '3',
  darkblue: '4',
  purple: '5',
  aqua: '6',
  normal: '7',
  yellow: '11',
  redish: '160',
  blue: '65',
  gray: '95',
  brown: '101',
  cursorlinebg: '235',
  black: '16',
  visual: '236',
  graish: '242',
  bright: '144',
}

const bold = { bold: 1 }
const italic = { italic: 1 }
const underline = { underline: 1 }
const bold_underline = { bold: 1, underline: 1 }

def HlSet(name: string, fg = 'NONE', bg = 'NONE', attr = {}, attr_color = 'NONE')
  hlset([{ name: name, ctermfg: fg, ctermbg: bg, cterm: attr, ctermul: attr_color,
           guifg: 'NONE', guibg: 'NONE', guisp: 'NONE', gui: {},
           start: 'NONE', stop: 'NONE', term: {} }])
enddef

def HlLinks(linksto: string, names: list<string>)
  var links = []
  for name in names
    add(links, { name: name, linksto: linksto, force: v:true })
  endfor
  hlset(links)
enddef

# HlSet('Normal', colors.normal, colors.norm_back)
hlset([{name: 'Normal', cleared: true, linksto: 'NONE'}])
HlLinks('Normal', [
  'CocOutlineName',
  'htmlTagN',
  'vimFuncSID',
  'vimSetSep',
  'vimSep',
  'vimContinue',
  'vimVar',
  'pythonDot',
  'cssVendor',
  'javaScriptBraces',
  'javaScriptParens',
  'jsGlobalNodeObjects',
  'jsGlobalObjects',
  'jsFuncParens',
  'jsParens',
  'typeScriptBraces',
  'typeScriptEndColons',
  'typeScriptDOMObjects',
  'typeScriptAjaxMethods',
  'typeScriptLogicSymbols',
  'typeScriptGlobalObjects',
  'typeScriptParens',
  'typeScriptOpSymbols',
  'typeScriptHtmlElemProperties',
  'markdownUrlDelimiter',
  'markdownLinkDelimiter',
  'markdownLinkTextDelimiter',
  'haskellSeparator',
  'haskellDelimiter',
  'jsonBraces',
  'jsonString',
  ]
)

# :help group-name
# :help highlight-default
HlSet('Comment', colors.gray)
HlLinks('Comment', [
  'xmlDocTypeDecl',
  'xmlCdataStart',
  'dtdFunction',
  'xmlProcessingDelim',
  'dtdParamEntityPunct',
  'dtdParamEntityDPunct',
  'xmlAttribPunct',
  'markdownBlockquote',
  'markdownListMarker',
  'markdownOrderedListMarker',
  'markdownRule',
  'markdownHeadingRule',
  'typeScriptDocSeeTag',
  'typeScriptDocParam',
  ]
)

HlSet('Constant', colors.purple)
HlLinks('Constant', [
  'Character',
  'Number',
  'Boolean',
  'Float',
  # ---
  'goConstants',
  'htmlScriptTag',
  'xmlDocTypeKeyword',
  'xmlCdataCdata',
  'dtdTagName',
  'cOperator',
  'pythonExceptions',
  'pythonBoolean',
  'javaScriptNumber',
  'javaScriptNull',
  'jsNull',
  'jsUndefined',
  'typeScriptNull',
  'markdownUrl',
  'haskellNumber',
  'haskellPragma',
  'svelteKeyword',
  ]
)

HlSet('String', colors.green)
HlLinks('String', [
  'Question',
  # ---
  'CocInfoSign',
  'GitGutterAdd',
  'diffAdded',
  'cssClassName',
  'cssImportant',
  'markdownUrlTitleDelimiter',
  'haskellString',
  'haskellChar',
  'jsonKeyword',
  'jsonQuote',
  ]
)

HlSet('Identifier', colors.blue)
HlLinks('Identifier', [
  'Conceal',
  'diffLine',
  # ---
  'htmlTag',
  'htmlEndTag',
  'xmlTag',
  'xmlEndTag',
  'xmlTagName',
  'xmlEqual',
  'pythonInclude',
  'pythonImport',
  'pythonRun',
  'pythonCoding',
  'cssBraces',
  'cssColor',
  'cssSelectorOp',
  'cssSelectorOp2',
  'javaScriptMember',
  'goDeclType',
  'CocPumMenu',
  ],
)

HlSet('Function', colors.darkblue)
HlLinks('Function', [
  'pythonDottedName',
  'luaFuncCall',
  'haskellIdentifier',
  'lispFunc',
  'vim9FuncCallUser',
  ]
)

HlSet('Statement', colors.red)
HlLinks('Statement', [
  'Conditional',
  'Repeat',
  'Label',
  'Operator',
  'Keyword',
  'Exception',
  'diffRemoved',
  # ---
  'CocErrorSign',
  'GitGutterDelete',
  'vimNotFunc',
  'vimFunction',
  'pythonDecorator',
  'pythonOperator',
  'pythonException',
  'pythonConditional',
  'pythonRepeat',
  'javaScriptIdentifier',
  'goDeclaration',
  'luaIn',
  'haskellOperators',
  'tomlTable',
  ]
)

HlSet('PreProc', colors.aqua)
HlLinks('PreProc', [
  'Include',
  'Define',
  'Macro',
  'PreCondit',
  'Structure',
  # ---
  'CocHintSign',
  'GitGutterChange',
  'GitGutterChangeDelete',
  'diffChanged',
  'htmlArg',
  'xmlAttrib',
  'pythonFunction',
  'cssTextProp',
  'cssAnimationProp',
  'cssTransformProp',
  'cssTransitionProp',
  'cssPrintProp',
  'cssBoxProp',
  'cssFontDescriptorProp',
  'cssFlexibleBoxProp',
  'cssBorderOutlineProp',
  'cssBackgroundProp',
  'cssMarginProp',
  'cssListProp',
  'cssTableProp',
  'cssFontProp',
  'cssPaddingProp',
  'cssDimensionProp',
  'cssRenderProp',
  'cssColorProp',
  'cssGeneratedContentProp',
  'javaScriptFunction',
  'jsClassKeyword',
  'jsExtendsKeyword',
  'jsExportDefault',
  'jsTemplateBraces',
  'jsFunction',
  'typeScriptReserved',
  'typeScriptLabel',
  'typeScriptFuncKeyword',
  'typeScriptInterpolationDelimiter',
  'goDirective',
  'luaFunction',
  'luaFunction',
  'markdownCode',
  'markdownCodeBlock',
  'markdownCodeDelimiter',
  'haskellLet',
  'haskellDefault',
  'haskellWhere',
  'haskellBottom',
  'haskellBlockKeywords',
  'haskellImportKeywords',
  'haskellDeclKeyword',
  'haskellDeriving',
  'haskellAssocType',
  ]
)

HlSet('Type', colors.yellow)
HlLinks('Type', [
  'Typedef',
  'LineNr',
  # ---
  'CocWarningSign',
  'diffNewFile',
  'vimCommand',
  'cssFunctionName',
  'cssUIProp',
  'cssPositioningProp',
  'jsClassDefinition',
  'markdownH5',
  'markdownH6',
  'haskellType',
  'tomlTableArray',
  ]
)

HlSet('Special', colors.orange)
HlLinks('Special', [
  'StorageClass',
  'SpecialChar',
  'Tag',
  'Delimiter',
  'SpecialComment',
  'Debug',
  'WarningMsg',
  'qfLineNr',
  'diffFile',
  # ---
  'htmlSpecialChar',
  'xmlEntity',
  'xmlEntityPunct',
  'vimNotation',
  'vimBracket',
  'vimMapModKey',
  'cStructure',
  'pythonBuiltin',
  'pythonBuiltinObj',
  'pythonBuiltinFunc',
  'cssIdentifier',
  'typeScriptIdentifier',
  'goBuiltins',
  'luaTable',
  'markdownHeadingDelimiter',
  'haskellBacktick',
  'haskellStatement',
  'haskellConditional',
  ]
)

HlSet('Underlined', colors.blue, v:none, underline)
HlSet('Ignore', '236')
HlSet('Error', colors.red, v:none, bold_underline)
HlSet('Todo', colors.normal, v:none, bold_underline)

HlSet('CursorLine', v:none, colors.cursorlinebg)
HlLinks('CursorLine', [
  'ColorColumn',
  'CursorColumn',
  'QuickFixLine',
  ]
)

HlSet('Cursor', colors.norm_back, '231')
HlLinks('Cursor', ['lCursor', 'CursorIM'])

HlSet('Directory', colors.green, v:none, bold)
HlLinks('Directory', [
  'markdownH1',
  'markdownH2',
  'CocGitAddedSign',
  ]
)

HlSet('DiffAdd', '232', '58')
HlSet('DiffChange', '232', '23')
HlSet('DiffDelete', '232', '52')
HlLinks('DiffAdd', ['DiffText'])

HlSet('NonText', '238')
HlLinks('NonText', [
  'EndOfBuffer',
  'SpecialKey',
  'LineNrAbove',
  'LineNrBelow',
  ]
)

HlSet('ErrorMsg', colors.red, v:none, bold)
HlLinks('ErrorMsg', ['CocGitRemovedSign', 'CocGitTopRemovedSign'])

HlSet('VertSplit', colors.black)
HlSet('Folded', colors.gray, '235')
HlLinks('Folded', ['FoldColumn'])
HlSet('IncSearch', '69', v:none, bold_underline)
HlSet('CursorLineNr', colors.yellow, colors.cursorlinebg)
HlSet('MatchParen', '201', v:none, bold)
HlSet('ModeMsg', '107', v:none, bold)
HlSet('MoreMsg', colors.yellow, v:none, bold)
HlLinks('MoreMsg', [
  'markdownH3',
  'markdownH4',
  'svelteRepeat',
  'svelteConditional'
  ]
)

HlSet('Pmenu', v:none, '234')
HlSet('PmenuSel', v:none, '235', bold)
HlSet('Visual', v:none, colors.visual)
HlLinks('Visual', ['PmenuSbar', 'VisualNOS'])
HlSet('PmenuThumb', v:none, colors.graish)
HlSet('Search', '34', v:none, bold_underline)
HlSet('SpellBad', v:none, v:none, underline, colors.redish)
HlSet('SpellCap', v:none, v:none, underline, '143')
HlLinks('SpellCap', ['SpellLocal', 'SpellRare'])
HlSet('StatusLine', '243', colors.black)
HlSet('StatusLineNC', '238', colors.black)
HlLinks('StatusLineNC', ['CocListPath'])
HlSet('StatusLineTerm', colors.green, colors.black, bold)
HlSet('StatusLineTermNC', '59', colors.black)
HlSet('TabLine', colors.graish, colors.black)
HlLinks('Tabline', ['TabLineFill'])
HlSet('TabLineSel', '101', colors.black, bold)
# HlSet('Terminal', colors.normal, colors)
HlSet('Title', '96', v:none, bold)
HlSet('WildMenu', colors.blue, colors.visual, bold)

HlSet('User1', '65', colors.black)
HlSet('User2', '47', colors.black, bold)
HlSet('User3', '137', colors.black)
HlSet('User4', '60', colors.black)
HlSet('User5', '96', colors.black)
HlSet('User6', '95', colors.black)
HlSet('User7', '167', colors.black, bold)

HlSet('SignColumn')
HlSet('qfError')
HlSet('qfFileName')
HlSet('PopupBorder', '71')

HlSet('ALEError', v:none, v:none, underline, '167')
HlSet('ALEWarning', v:none, v:none, underline, '178')
HlSet('ALEInfo', v:none, v:none, underline, '112')
HlSet('AleErrorSign', colors.red, v:none, bold)
HlSet('AleWarningSign', colors.orange, v:none, bold)
HlSet('AleInfoSign', colors.green, v:none, bold)

HlSet('CocHoverRange', v:none, '237')
HlLinks('CocHoverRange', ['CocCursorRange'])
HlLinks('Pmenu', ['CocFloating', 'CocNotification'])
HlLinks('PmenuSel', ['CocMenuSel'])
HlSet('CocListMode', '100', colors.black, bold)
HlSet('CocErrorHighlight', v:none, v:none, underline, '167')
HlSet('CocWarningHighlight', v:none, v:none, underline, '178')
HlSet('CocInfoHighlight', v:none, v:none, underline, '112')
HlSet('CocHintHighlight', v:none, v:none, underline, '77')
HlSet('CocGitChangedSign', v:none, v:none, bold, '71')
HlLinks('CocGitChangedSign', ['CocGitChangeRemovedSign'])
HlSet('CocPumSearch', v:none, v:none, underline)

HlSet('debugPC', v:none, '23')
HlSet('debugBreakpoint', colors.red, v:none, { reverse: 1, bold: 1 })
HlLinks('htmlTagName', [
  'htmlSpecialTagName',
  'docbkKeyword',
  ]
)

HlSet('lispParen', '240')

HlSet('htmlLink', colors.bright, v:none, underline)
HlSet('htmlBold', colors.normal, v:none, bold)
HlSet('htmlBoldUnderline', colors.normal, v:none, bold_underline)
HlSet('htmlBoldItalic', colors.normal, v:none, { bold: 1, italic: 1 })
HlSet('htmlBoldUnderlineItalic', colors.normal, v:none, { bold: 1, underline: 1, italic: 1 })
HlSet('htmlUnderline', colors.normal, v:none, underline)
HlSet('htmlUnderlineItalic', colors.normal, v:none, { underline: 1, italic: 1 })
HlSet('htmlItalic', colors.normal, v:none, italic)

HlSet('vimCommentTitle', colors.bright, v:none, bold)
HlLinks('vimFuncName', ['vimSubst'])
HlLinks('vimComment', ['vimCommentString'])
HlSet('typeScriptDocTags', colors.bright, v:none, bold)

HlSet('markdownItalic', colors.normal, v:none, italic)
HlSet('markdownLinkText', colors.gray, v:none, underline)
HlLinks('markdownLinkText', ['markdownIdDeclaration'])

HlSet('StargateFocus', '101')
HlSet('StargateDesaturate', '238')
HlSet('StargateError', colors.red)
HlSet('StargateLabels', colors.yellow, '234')
HlSet('StargateErrorLabels', colors.yellow, '52')
HlSet('StargateMain', '198', v:none, bold)
HlSet('StargateSecondary', '42', v:none, bold)
HlSet('StargateShip', '233', colors.yellow)
HlSet('StargateVIM9000', '233', colors.purple, bold)
HlSet('StargateMessage', '143')
HlSet('StargateErrorMessage', '167')
HlSet('StargateVisual', v:none, '235')

# vim: set tw=80 fdm=marker:
