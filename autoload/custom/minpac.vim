vim9script

final g:minpac_plugins = {}
final delayed_plugins = {}
const pack_dir = $'{$HOME}/.vim/pack/minpac/opt'

def PackInit()
  packadd minpac
  minpac#init({
    progress_open: 'tab',
    status_open: 'vertical',
    verbose: 3,
  })
  minpac#add('k-takata/minpac', {'type': 'opt'})

  for p in keys(g:minpac_plugins)
    minpac#add(p, g:minpac_plugins[p])
  endfor
enddef

command! PackUpdate PackInit() | minpac#update()
command! PackClean PackInit() | minpac#clean()
command! PackStatus PackInit() | minpac#status()

def GetRepo(url: string): string
  return matchstr(url, '[^/]\{-}\ze\%(\.git\)\?$')
enddef

export def Add(url: string, opts: dict<any> = {})
  const repo = GetRepo(url)
  if isdirectory($'{pack_dir}/{repo}')
    if !get(opts, 'Config')
      exe $'packadd! {repo}'
    else
      if !!get(opts, 'delay')
        delayed_plugins[repo] = {
          delay: opts.delay,
          Config: opts.Config,
        }
        autocmd_add([{
          event: 'VimEnter',
          pattern: '*',
          group: 'MinPac',
          once: true,
          cmd: $'timer_start(delayed_plugins["{repo}"].delay, (_) => delayed_plugins["{repo}"].Config())',
        }])
      else
        opts.Config()
      endif
      remove(opts, 'Config')
    endif
  else
    echom $'Missing {repo} plugin. Run :PackUpdate to install it.'
    if !!get(opts, 'Config')
      remove(opts, 'Config')
    endif
  endif

  final default_opts: dict<any> = { type: 'opt' }
  g:minpac_plugins[url] = extend(default_opts, opts, 'force')
  if !!get(opts, 'dependencies')
    for dp in opts.dependencies
      g:minpac_plugins[dp] = { type: 'opt' }
    endfor
  endif
enddef
