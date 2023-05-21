vim9script

final minpac_plugins = {}
final delayed_plugins = {}
const pack_dir = $'{$HOME}/.vim/pack/minpac/opt'
const default_opts: dict<any> = { type: 'opt' }

def PackInit()
  packadd minpac
  minpac#init({
    progress_open: 'tab',
    status_open: 'vertical',
    verbose: 2,
  })
  minpac#add('k-takata/minpac', {'type': 'opt'})

  for p in keys(minpac_plugins)
    minpac#add(p, minpac_plugins[p])
  endfor
enddef

command! PackUpdate PackInit() | minpac#update()
command! PackClean PackInit() | minpac#clean()
command! PackStatus PackInit() | minpac#status()

def GetRepo(url: string): string
  return matchstr(url, '[^/]\{-}\ze\%(\.git\)\?$')
enddef

export def Do(plug: string, cmd: list<string>)
  echow $'Running {plug} hook...'
  job_start(cmd, {
    err_cb: (_, e) => {
      echow e
    },
    exit_cb: (_, _) => {
      echow $'{plug} hook finished.'
    }})
enddef

export def Add(url: string, opts: dict<any> = null_dict)
  var initialize = true

  const repo = GetRepo(url)
  if !isdirectory($'{pack_dir}/{repo}')
    timer_start(20, (_) => {
      echow $'Missing {repo} plugin. Run :PackUpdate to install it.'
    })
    initialize = false
  endif

  if opts == null_dict
    if initialize
      exe $'packadd! {repo}'
    endif
    minpac_plugins[url] = default_opts
    return
  endif


  if initialize && !!get(opts, 'Config')
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

  minpac_plugins[url] = extend(opts, default_opts, 'keep')
enddef
