;;; with-editor-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "with-editor" "with-editor.el" (0 0 0 0))
;;; Generated autoloads from with-editor.el

(autoload 'with-editor-export-editor "with-editor" "\
Teach subsequent commands to use current Emacs instance as editor.

Set and export the environment variable ENVVAR, by default
\"EDITOR\".  The value is automatically generated to teach
commands to use the current Emacs instance as \"the editor\".

This works in `shell-mode', `term-mode', `eshell-mode' and
`vterm'.

\(fn &optional (ENVVAR \"EDITOR\"))" t nil)

(autoload 'with-editor-export-git-editor "with-editor" "\
Like `with-editor-export-editor' but always set `$GIT_EDITOR'." t nil)

(autoload 'with-editor-export-hg-editor "with-editor" "\
Like `with-editor-export-editor' but always set `$HG_EDITOR'." t nil)

(defvar shell-command-with-editor-mode nil "\
Non-nil if Shell-Command-With-Editor mode is enabled.
See the `shell-command-with-editor-mode' command
for a description of this minor mode.")

(custom-autoload 'shell-command-with-editor-mode "with-editor" nil)

(autoload 'shell-command-with-editor-mode "with-editor" "\
Teach `shell-command' to use current Emacs instance as editor.

This is a minor mode.  If called interactively, toggle the
`Shell-Command-With-Editor mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='shell-command-with-editor-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

Teach `shell-command', and all commands that ultimately call that
command, to use the current Emacs instance as editor by executing
\"EDITOR=CLIENT COMMAND&\" instead of just \"COMMAND&\".

CLIENT is automatically generated; EDITOR=CLIENT instructs
COMMAND to use to the current Emacs instance as \"the editor\",
assuming no other variable overrides the effect of \"$EDITOR\".
CLIENT may be the path to an appropriate emacsclient executable
with arguments, or a script which also works over Tramp.

Alternatively you can use the `with-editor-async-shell-command',
which also allows the use of another variable instead of
\"EDITOR\".

\(fn &optional ARG)" t nil)

(autoload 'with-editor-async-shell-command "with-editor" "\
Like `async-shell-command' but with `$EDITOR' set.

Execute string \"ENVVAR=CLIENT COMMAND\" in an inferior shell;
display output, if any.  With a prefix argument prompt for an
environment variable, otherwise the default \"EDITOR\" variable
is used.  With a negative prefix argument additionally insert
the COMMAND's output at point.

CLIENT is automatically generated; ENVVAR=CLIENT instructs
COMMAND to use to the current Emacs instance as \"the editor\",
assuming it respects ENVVAR as an \"EDITOR\"-like variable.
CLIENT may be the path to an appropriate emacsclient executable
with arguments, or a script which also works over Tramp.

Also see `async-shell-command' and `shell-command'.

\(fn COMMAND &optional OUTPUT-BUFFER ERROR-BUFFER ENVVAR)" t nil)

(autoload 'with-editor-shell-command "with-editor" "\
Like `shell-command' or `with-editor-async-shell-command'.
If COMMAND ends with \"&\" behave like the latter,
else like the former.

\(fn COMMAND &optional OUTPUT-BUFFER ERROR-BUFFER ENVVAR)" t nil)

(register-definition-prefixes "with-editor" '("server-" "shell-command" "start-file-process" "with-editor"))

;;;***

(provide 'with-editor-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; with-editor-autoloads.el ends here
